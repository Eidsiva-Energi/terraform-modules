### Confluent Cloud Compute Pool Configuration

This section provides details about the configurable variables used to set up a compute pool in Confluent Cloud.

| **Variable**                     | **Description**                                                                                     | **Type**         | **Default**                                      |
|----------------------------------|-----------------------------------------------------------------------------------------------------|------------------|--------------------------------------------------|
| `environment_id`                 | The Confluent Cloud environment ID.                                                                 | `string`         | N/A                                              |
| `display_name`                   | The display name of the compute pool.                                                              | `string`         | N/A                                              |
| `region`                         | The region of the compute pool.                                                                      | `string`         | `westeurope`                                    |
| `max_cfu`                       | The maximum number of CFUs for the compute pool.                                                  | `number`         | `5`                                             |

### Validation Constraints
- **Maximum CFUs**: Must be `5`, `10`, `20`, `30`, `40`, or `50`.
