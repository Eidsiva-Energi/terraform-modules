# topics-terraform


## Example


```
module "test-kafka" {
    source = "github.com/Eidsiva-Energi/terraform-modules/kafka-topics"

    schema_registry_config = local.schema_registry_config
    environment = var.environment
    service_account_map = confluent_service_account.system

    domain = "domain"
    system = "system"
    data_name = "data_name"

    enable_prod = false
    is_public = false
    retention_ms = 604800000 # 7 days
    partitions = 1

    consumers = {
      consumer = {
        system_name = "system",
        application_name = "application",
      }
    }
}
```