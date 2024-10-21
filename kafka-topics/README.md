# Kafka terraform module
A module for defining topics and schemas in Kafka clusters owned by the Eidsiva group and it's daugther companies


## Topics
* Topics are defined in `main.tf`
* All topics are owned by a single domain e.g. HR
* Topic names follow this convention: {public||private}.{domain}.{system}.{data_name}
  * Public/Private signify wether or not a topic contains data that is relevant to consumers outside of the domain.
  * Note that consumers outside of a given domain are not blocked from consuming topics marked private.


### Example 1
This example defines a topic named `public.hr.ifs.employeeworklocation` with a `mdmx-ticket-updater` as a consumer. The topic retains its messages for 7 days.


```c
module "test-kafka" {
    source = "github.com/Eidsiva-Energi/terraform-modules/kafka-topics"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id

    schema_registry_config = local.schema_registry_config
    service_account_map    = confluent_service_account.system

    domain = "hr"
    system = "ifs"
    data_name = "employeeworklocation"

    enable_prod = true
    is_public = true
    retention_ms = 604800000 # 7 days
    partitions = 1

    consumers = {
      mdmx_ticket_updater_consumer = {
        system_name = "mdmx",
        application_name = "ticket-updater",
      }
    }
}
```

#### Variables

* `domain` designates which domain the topic belongs to. It should be set from a approved set of values.
* `system` referes to the main system producing messages on this topic.
* `data_name` is the main title of the topic and should give potential consumers an idea of what the messages on this topic will contain.
* `enable_prod` !!FUNCTIONALITY IS NOT IMPLEMENTED YET, BUT THE VARIABLE IS REQUIRED FOR THE MODULE TO FUNCTION!!
* `is_public` decides if the topic will be prefixed with `public` or `private`. This prefix is used to inform potential consumers wether the topic is intended for use outside the organisation.
* `retention_ms`. How long messages on the topic will be stored. *Example 1* stores messages for 7 days. A value of `-1` means topics will be stored forever.
* `partitions`. How many partitions should be dedicated to this topic. Each partition can handle at least 10 MB/s of traffic.