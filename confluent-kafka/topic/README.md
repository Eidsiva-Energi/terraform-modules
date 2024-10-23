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

* `domain`    The domain that owns the topic and contract.
* `system`    The system that owns the topic and contract. Only this system can publish to the topic. 
* `data_name` The name of the data type or event type. Should give potential consumers an idea of what the messages on this topic will contain.
* `enable_prod` Enable to create the topic in the production environment. Useful to disable prod during development.
* `is_public` Decides if the topic will be prefixed with `public` or `private`. This prefix is used to inform potential consumers whether the topic is intended for use outside the domain.
* `retention_ms`. How long messages on the topic will be stored. *Example 1* stores messages for 7 days. A value of `-1` means topics will be stored forever.
* `cleanup_policy`. 'delete' or 'compact'. 'delete' will delete old segments when retentions_ms is reached. 'compact' will enable log compaction on the topic.
* `partitions`. How many partitions should be dedicated to this topic. Each partition can handle at least 10 MB/s of traffic.
* `consumers`. A map of consumers that will be allowed to consume messages from this topic. Each consumer is defined by a unique key and a map with the keys `system_name` and `application_name`. The  consumer will be allowed to consume messages from the topic if the consumer's system and application name matches the values in the map.
* `schema`. Relative path to the schema that will be used to validate messages on the topic.

| **Variable**              | **Description**                                                                                                 | **Type**      | **Default**                                |
|---------------------------|-----------------------------------------------------------------------------------------------------------------|---------------|--------------------------------------------|
| `domain`                  | The domain that owns the topic and contract.                                                                    | `string`      | N/A                                        |
| `system`                  | The system that owns the topic and contract. Only this system can publish to the topic.                         | `string`      | N/A                                        |
| `data_name`               | The name of the data or event type. Should describe the contents of the topic to potential consumers.           | `string`      | N/A                                        |
| `enable_prod`             | Allows topic to be created in the production environment.                                                       | `boolean`     | N/A                                        |
| `is_public`               | Prefixes topic with `public` or `private`. Informs potentials consumers if the  topic is intended for use outside the domain.   | `boolean` | N/A                            |
| `retention_ms`            | How long messages are stored. *Example 1* store messages for 7 days -1 means stored indefinitely.               | `number`      | N/A                                        |
| `cleanup_policy`          | 'delete' or 'compact'. 'delete' removes old data; 'compact' enables log compaction.                             | `string`      | N/A                                        |
| `partitions`              | Number of partitions dedicated to the topic. Each can handle at least ~10 MB/s of traffic.                      | `number`      | N/A                                             |
| `consumers`               | Map of allowed consumers. Each consumer is defined bu a unique key and a map with the keys `system_name` and `application_name`.| `map(object)` | N/A                        |
| `schema`                  | Relative path to the schema that will be used to validate messages on the topic.                                | `string`      | N/A                                        |

<!--->
### Validation Constraints
- **Data Format**: Must be either `JSON` or `AVRO`.
- **Time Interval**: Must be either `HOURLY` or `DAILY`.