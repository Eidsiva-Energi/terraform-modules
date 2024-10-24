# Confluent Kafka MySQL Sink Connector

This module defines a Kafka connector that stores a compacted topic in a MySQL database.

## Example 1
This example defines a connector called `myconnector` that upserts the contents for the topic `public.hr.ifs.companyorg` to a MySQL Database.

```c
module "connector" {
    source = "github.com/Eidsiva-Energi/terraform-modules/confluent-kafka/connectors/mysql-sink"

    cluster_id     = local.cluster_id
    environment_id = local.environment_id

    name = "myconnector"
    
    topics = {
      mytopic = {
        topic_name = "public.hr.ifs.companyorg"
        }
    }

    service_account_id = confluent_service_account.system["mysystem"].id

    db_name = "mydatabase"
    connection_host = "myhost"
    connection_port = 3306
    connection_user = "myuser"
    connection_password = "********"
}
```

### Variables

| **Variable**                    | **Description**                                                                 | **Type**         | **Default**       |
|----------------------------------|---------------------------------------------------------------------------------|------------------|-------------------|
| `name`                           | The name of the connector.                                                      | `string`         | N/A               |
| `environment_id`                 | The Confluent Cloud environment ID.                                             | `string`         | N/A               |
| `cluster_id`                     | The Confluent Cloud cluster ID.                                                 | `string`         | N/A               |
| `service_account_id`             | The Confluent Cloud service account ID.                                         | `string`         | N/A               |
| `db_name`                        | The name of the database.                                                       | `string`         | N/A               |
| `connection_host`                | The host of the database.                                                       | `string`         | N/A               |
| `connection_port`                | The port of the database.                                                       | `number`         | N/A               |
| `connection_user`                | The user of the database.                                                       | `string`         | N/A               |
| `connection_password`            | The password of the database.                                                   | `string`         | N/A               |
| `topics`                         | A map of topics to be stored in blob storage, each containing a `topic_name`.   | `map(object)`    | N/A               |
| `mode`                           | The mode of the connector. Must be either `INSERT` or `UPSERT`.                 | `string`         | `UPSERT`          |
| `input_data_format`              | The input data format. Must be one of `AVRO`, `JSON_SR`, or `PROTOBUF`.  | `string`         | `JSON_SR`            |
| `input_key_format`               | The input key format. Must be one of `AVRO`, `JSON_SR`, `PROTOBUF`, or `STRING`.   | `string`         | `STRING`          |
| `table_and_column_auto_create`   | Enables auto-creation of tables and columns. Must be either `true` or `false`.  | `string`         | `true`            |
| `table_and_column_auto_evolve`   | Enables auto-evolution of tables and columns. Must be either `true` or `false`. | `string`         | `true`            |
| `pk_mode`                        | The primary key mode. Must be one of `none`, `record_key`, `record_value`, or `kafka`. | `string`         | `none`            |

### Validation Constraints
- **Mode**: Must be either `INSERT` or `UPSERT`.
- **Input Data Format**: Must be one of `AVRO`, `JSON_SR`, or `PROTOBUF`.
- **Input Key Format**: Must be one of `AVRO`, `JSON_SR`, `PROTOBUF`, or `STRING`.
- **Table and Column Auto Creation/Evolution**: Must be `true` or `false`.
- **Primary Key Mode**: Must be one of `none`, `record_key`, `record_value`, or `kafka`.
- **Connection Host**: Do not include jdbc:xxxx:// in the connection hostname property.