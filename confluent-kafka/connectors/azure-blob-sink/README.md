# Kafka Connector Module

This module defines a Kafka connector that stores messages from one or multiple topics in Azure blob storage.

## Example 1
This example defines a connector called `myconnector` that writes the contents for the topics `public.hr.ifs.companyorg` and `public.hr.companyperson` to Azure blob storage. The contents are saved daily as JSON files and the files are organized by which day they were written.

```c
module "connector" {
    source = "github.com/Eidsiva-Energi/terraform-modules/confluent-kafka/connectors/azure-blob-sink"

    name = "myconnector"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id

    service_account_id = confluent_service_account.system["mysystem"].id

    account_name = "myserviceaccount"
    account_key = "********"
    container_name = "mycontainer"

    topics = {
        mytopic = {
            topic_name = "public.hr.ifs.companyorg"
        }
        mysecondtopic = {
            topic_name = "public.hr.companyperson"
        }
    }

    data_format = "JSON"
    time_interval = "DAILY"
    path_format = "'year'=YYYY/'month'=MM/'day'=dd"
}
```

### Confluent Cloud Kafka to Azure Blob Storage Connector Configuration

This section provides details about the configurable variables used to set up a Kafka connector for Confluent Cloud, which stores data in Azure Blob Storage.

| **Variable**              | **Description**                                                                                 | **Type**         | **Default**                                |
|---------------------------|-------------------------------------------------------------------------------------------------|------------------|--------------------------------------------|
| `name`                    | The name of the connector.                                                                      | `string`         | N/A                                        |
| `environment_id`           | The Confluent Cloud environment ID.                                                             | `string`         | N/A                                        |
| `cluster_id`               | The Confluent Cloud cluster ID.                                                                 | `string`         | N/A                                        |
| `service_account_id`       | The Confluent Cloud service account ID.                                                         | `string`         | N/A                                        |
| `account_name`             | The Azure Storage account name.                                                                 | `string`         | N/A                                        |
| `container_name`           | The Azure Storage account container name.                                                       | `string`         | N/A                                        |
| `account_key`              | The value of the Azure Storage account key.                                                     | `string`         | N/A                                        |
| `topics`                   | A map of topics to be stored in blob storage, each containing a `topic_name`.                   | `map(object)`    | N/A                                        |
| `data_format`              | The format of the data being stored. Must be either `JSON` or `AVRO`.                           | `string`         | `JSON`                                     |
| `path_format`              | The file structure format.                                                                     | `string`         | `'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH`|
| `time_interval`            | The time interval for file organization. Must be either `HOURLY` or `DAILY`.                    | `string`         | N/A                                        |
| `rotate_interval_ms`       | The time interval in milliseconds to invoke file commits.                                       | `number`         | `-1`                                       |

### Validation Constraints
- **Data Format**: Must be either `JSON` or `AVRO`.
- **Time Interval**: Must be either `HOURLY` or `DAILY`.

