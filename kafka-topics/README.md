# Kafka terraform module
A module for defining topics, connectors, and schemas in Kafka clusters owned by the Eidsiva group and it's daugther companies


## Topics
* Topics are defined in `main.tf`
* All topics are owned by a single domain e.g. HR
* Topic names follow this convention: {public||private}.{domain}.{system}.{data_name}
  * Public/Private signify wether or not a topic contains data that is relevant to consumers outside of the domain.
  * Note that consumers outside of a given domain are not blocked from consuming topics marked private.


### Example


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

    connectors = {
      connector = {
        name           = "myConnector"
        system_name    = "system"
        is_sink        = true
        format         = "JSON"
        account_name   = "AzureStorageAccount"
        account_key    = "*******"
        container_name = "BlobContainer"
      }
    }
}
```