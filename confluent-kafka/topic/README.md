# Kafka terraform module
A module for defining topics and schemas in Kafka clusters owned by the Eidsiva group and its daughter companies


## Topics
* All topics are owned by a single domain e.g. HR
* Topic names follow this convention: {public||private}.{domain}.{system}.{data_name}
  * Public/Private signify whether or not a topic contains data that is relevant to consumers outside of the domain.
  * Note that consumers outside of a given domain are not blocked from consuming topics marked private.


### Example 1
This example defines a topic named `public.hr.ifs.employeeworklocation` with a `mdmx-ticket-updater` as a consumer. The topic retains its messages for 7 days.


```c
module "test-kafka" {
    source = "github.com/Eidsiva-Energi/terraform-modules/confluent-kafka/topic"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id
    environment    = var.environment

    schema_registry_config = local.schema_registry_config
    service_account_map    = confluent_service_account.system

    domain = "hr"
    system = "ifs"
    data_name = "employeeworklocation"

    enable_prod = true
    is_public = true
    retention_ms = 604800000 # 7 days
    cleanup_policy = "delete"
    partitions = 1

    consumers = {
      mdmx_ticket_updater_consumer = {
        system_name = "mdmx",
        application_name = "ticket-updater",
      }
    }

    schema = file("../schema.json")
}
```

#### Variables
NOTE: All variables without a default value needs to be given a value in your terraform definition

| **Variable**              | **Description**                                                                                                 | **Type**      | **Default**               |
|---------------------------|-----------------------------------------------------------------------------------------------------------------|---------------|---------------------------|
| `domain`                  | The domain that owns the topic and contract.                                                                    | `string`      | N/A                       |
| `system`                  | The system that owns the topic and contract. Only this system can publish to the topic.                         | `string`      | N/A                       |
| `data_name`               | The name of the data or event type. Should describe the contents of the topic to potential consumers.           | `string`      | N/A                       |
| `is_public`               | Prefixes topic with `public` or `private`. Informs potentials consumers if the  topic is intended for use outside the domain.   | `boolean` | `true`        |
| `retention_ms`            | How long messages are stored. *Example 1* store messages for 7 days -1 means stored indefinitely.               | `number`      | N/A                       |
| `cleanup_policy`          | 'delete' or 'compact'. 'delete' removes old data; 'compact' enables log compaction.                             | `string`      | 'delete'                  |
| `partitions`              | Number of partitions dedicated to the topic. Each can handle at least ~10 MB/s of traffic.                      | `number`      | 1                         |
| `consumers`               | Map of allowed consumers. Each consumer is defined by a unique key and a map with the keys `system_name` and `application_name`.| `map(object)` | N/A       |
| `schema`                  | Object defining a schema's configuration. By default, all topics require a schema.                              | `object`      | N/A                       |
| `schema.path`             | Either a local (relative) path to the .json file defining the schema, or a URL to a file hosted on the internet (for example a public GitHub Repo)                                                                                                                                         | `string`      | N/A                       |
| `schema.format`           | The format of the schema.                                                                                       | `string`      | N/A                       |
| `schema.use_producer_defined` | Used to turn off the requirement for each topic to have a schema. Meant to be used with topics where the producer defines the schema. |`boolean`| false |


#### Validation Constraints
- `data_name`: Can only contain lowercase letters [a-z], digits [0-9], and underscores. Must begin with a lowercase letter. 
- `cleanup_policy`: Must be either *'delete'* or *'compact'*
- `schema`: Must have either the parameters `path` and `format` defined or `use_producer_defined` defined.
- `schema.format`: Must be either *'JSON'* or *'AVRO'*.
- `schema.path`: If you are using an URL, it must be HTTPS.
