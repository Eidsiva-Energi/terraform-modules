# Kafka Connector Module

This module defines a Kafka connector that stores messages from one or multiple topics in Azure Data Lake.

## Example 1
This example defines a connector called `myconnector` that writes the contents for the topics `public.hr.ifs.companyorg` and `public.hr.companyperson` to Azure Data Lake. The contents are saved daily as JSON files and the files are organized by which day they were written.

```c
module "connector" {
    source = "github.com/Eidsiva-Energi/terraform-modules/confluent-kafka/connectors/azure-data-lake-gen2-sink"

    name = "myconnector"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id

    service_account_id = confluent_service_account.system["mysystem"].id

    account_name = "myserviceaccount"
    account_key = "********"



    topics = {
        mytopic = {
            topic_name = "public.hr.ifs.companyorg"
        }
        mysecondtopic = {
            topic_name = "public.hr.companyperson"
        }
    }

    input_data_format = "JSON_SR"
    output_data_format = "JSON"
    time_interval = "DAILY"
    path_format = "'year'=YYYY/'month'=MM/'day'=dd"

    transforms = {
        insertKafkaTimestamp = {
        type              = "org.apache.kafka.connect.transforms.InsertField$Value"
        "timestamp.field" = "kafka_timestamp"
        }
    }
}
```
### Confluent Cloud Kafka to Azure Blob Storage Connector Configuration

This section provides details about the configurable variables used to set up a Kafka connector for Confluent Cloud, which stores data in Azure Blob Storage.

| **Variable**              | **Description**                                                                                | **Type**           | **Default**                                 |
|---------------------------|------------------------------------------------------------------------------------------------|--------------------|---------------------------------------------|
| `name`                    | The name of the connector.                                                                     | `string`           | N/A                                         |
| `environment_id`          | The Confluent Cloud environment ID.                                                            | `string`           | N/A                                         |
| `cluster_id`              | The Confluent Cloud cluster ID.                                                                | `string`           | N/A                                         |
| `topics`                  | A map of topics to be stored in blob storage, each containing a `topic_name`.                  | `map(object)`      | N/A                                         |
| `service_account_id`      | The Confluent Cloud service account ID.                                                        | `string`           | N/A                                         |
| `topics_dir`              | The directory to store the topics in blob storage. The entry should not start with `/`.        | `string`           | `topics`                                    |
| `account_name`            | The Azure Storage account name.                                                                | `string`           | N/A                                         |
| `account_key`             | The value of the Azure Storage account key.                                                    | `string`           | N/A                                         |
| `input_data_format`       | The format of the input data. Must be `JSON`, `AVRO`, `JSON_SR`, or `BYTES`.                   | `string`           | `JSON`                                      |
| `output_data_format`      | The format of the output data. Must be `JSON`, `AVRO`, `JSON_SR`, or `BYTES`.                  | `string`           | `JSON`                                      |
| `path_format`             | The file structure format.                                                                     | `string`           | `'year'=YYYY/'month'=MM/'day'=dd/'hour'=HH` |
| `time_interval`           | The time interval for file organization. Defaults to `DAILY`.                                  | `string`           | `DAILY`                                     |
| `flush_size`              | The number of records to write to Azure Blob Storage before flushing the data.                 | `number`           | `1000`                                      |
| `timestamp_field`         | Sets the field that contains the timestamp used for the TimeBasedPartitioner.                  | `string`           | `""`                                        |
| `timezone`                | The timezone to use for the TimeBasedPartitioner.                                              | `string`           | `UTC`                                       |
| `enable_connect_metadata` | Enables the connector to include metadata in the records.                                      | `boolean`          | `true`                                      |
| `max_poll_interval_ms`    | The maximum amount of time in milliseconds the connector will wait between polling the topics. | `number`           | `300000`                                    |
| `max_poll_records`        | The maximum number of records to consume from Kafka in a single request.                       | `number`           | `500`                                       |
| `tasks_max`               | The maximum number of tasks to use for this connector.                                         | `number`           | `1`                                         |
| `transforms`              | A map of transform configurations                                                              | `map(map(string))` | `{}`                                        |


### Validation Constraints
- **Input and Output Data Format**: Must be either `JSON`, `AVRO`, `JSON_SR`, or `BYTES`.
