### Confluent Cloud Kafka to Microsoft SQL Server Sink Connector Configuration

This section provides details about the configurable variables used to set up a Kafka connector for Confluent Cloud, which stores data in Microsoft SQL Server.

| **Variable**                     | **Description**                                                                                     | **Type**         | **Default**                                      |
|----------------------------------|-----------------------------------------------------------------------------------------------------|------------------|--------------------------------------------------|
| `name`                           | The name of the connector.                                                                          | `string`         | N/A                                              |
| `environment_id`                 | The Confluent Cloud environment ID.                                                                 | `string`         | N/A                                              |
| `cluster_id`                     | The Confluent Cloud cluster ID.                                                                     | `string`         | N/A                                              |
| `kafka_auth_mode`                | The Kafka authentication mode. Must be `KAFKA_API_KEY` or `SERVICE_ACCOUNT`.                       | `string`         | N/A                                              |
| `service_account_id`             | The Confluent Cloud service account ID, required when `kafka_auth_mode` is `SERVICE_ACCOUNT`.       | `string`         | N/A                                              |
| `kafka_api_key`                  | The Kafka API key, required when `kafka_auth_mode` is `KAFKA_API_KEY`.                              | `string`         | N/A                                              |
| `kafka_api_secret`               | The Kafka API secret, required when `kafka_auth_mode` is `KAFKA_API_KEY`.                           | `string`         | N/A                                              |
| `db_name`                        | The name of the database to connect to.                                                             | `string`         | N/A                                              |
| `connection_host`                | The host of the database.                                                                           | `string`         | N/A                                              |
| `connection_port`                | The port of the database.                                                                           | `number`         | N/A                                              |
| `connection_user`                | The user for database authentication.                                                               | `string`         | N/A                                              |
| `connection_password`            | The password for database authentication.                                                           | `string`         | N/A                                              |
| `topics`                         | A map of topics to be stored in the SQL database, each containing a `topic_name`.                   | `map(object)`    | N/A                                              |
| `mode`                           | The mode of the connector, either `INSERT` or `UPSERT`.                                            | `string`         | `UPSERT`                                         |
| `tasks_max`                      | The maximum number of tasks for the connector.                                                      | `number`         | `1`                                              |
| `input_data_format`              | The input data format for the connector. Must be `AVRO`, `JSON_SR`, or `PROTOBUF`.                  | `string`         | `JSON_SR`                                        |
| `input_key_format`               | The input key format. Must be `AVRO`, `JSON_SR`, `PROTOBUF`, or `STRING`.                           | `string`         | `STRING`                                         |
| `table_and_column_auto_create`   | Enables automatic creation of tables and columns. Must be `true` or `false`.                        | `string`         | `true`                                           |
| `table_and_column_auto_evolve`   | Enables automatic evolution of tables and columns. Must be `true` or `false`.                       | `string`         | `true`                                           |
| `table_name_format`              | The format for naming tables in the database.                                                       | `string`         | N/A                                              |
| `pk_mode`                        | The primary key mode. Must be `none`, `record_key`, `record_value`, or `kafka`.                     | `string`         | `kafka`                                          |
| `pk_fields`                      | Comma-separated list of primary key field names, based on `pk_mode`.                                | `string`         | `""` |

### Validation Constraints
- **Kafka Authentication Mode**: Must be either `KAFKA_API_KEY` or `SERVICE_ACCOUNT`.
- **Mode**: Must be either `INSERT` or `UPSERT`.
- **Input Data Format**: Must be `AVRO`, `JSON_SR`, or `PROTOBUF`.
- **Input Key Format**: Must be `AVRO`, `JSON_SR`, `PROTOBUF`, or `STRING`.
- **Table and Column Auto Create**: Must be either `true` or `false`.
- **Table and Column Auto Evolve**: Must be either `true` or `false`.
- **Primary Key Mode**: Must be `none`, `record_key`, `record_value`, or `kafka`.
