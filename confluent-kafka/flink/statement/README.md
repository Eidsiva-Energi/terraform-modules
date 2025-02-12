### Confluent Cloud Flink Statement Configuration

This section provides details about the configurable variables used to set up a Flink statement in Confluent Cloud.

| **Variable**      | **Description**                                        | **Type**      | **Default** |
|-------------------|--------------------------------------------------------|---------------|-------------|
| `organization_id` | The Confluent Cloud organization ID.                   | `string`      | N/A         |
| `environment_id`  | The Confluent Cloud environment ID.                    | `string`      | N/A         |
| `compute_pool_id` | The Confluent Cloud compute pool ID.                   | `string`      | N/A         |
| `principal_id`    | The ID of the principal used to run the statement.     | `string`      | N/A         |
| `statement_name`  | The displayed name of the statement                    | `string`      | N/A         |
| `statement`       | The SQL statement.                                     | `string`      | N/A         |
| `properties`      | Properties of the statement.                           | `map(string)` | N/A         |
| `rest_endpoint`   | The REST endpoint of Flink Region.                     | `string`      | N/A         |
| `stopped`         | Whether the statement is stopped.                      | `bool`        | `false`     |
| `key`             | The key for the principal used to run the statement.   | `string`      | N/A         |
| `secret`          | The secret for the principal used to run the statement | `string`      | N/A         |

