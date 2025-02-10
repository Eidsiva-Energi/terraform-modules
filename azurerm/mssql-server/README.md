### SQL Server Configuration Variables

This section provides details about configurable variables for setting up an SQL Server resource in Azure.

| **Variable**               | **Description**                                                                                                 | **Type**  | **Default** |
|----------------------------|-----------------------------------------------------------------------------------------------------------------|-----------|-------------|
| `name`                     | The name of the SQL Server instance.                                                                            | `string`  | N/A         |
| `server_version`           | Specifies the version of the SQL Server.                                                                        | `string`  | `"12.0"`    |
| `environment`              | The environment designation for the SQL Server instance (e.g., dev, prod).                                      | `string`  | N/A         |
| `organization`             | The organization name associated with the SQL Server instance.                                                  | `string`  | N/A         |
| `resource_group`           | The resource group in which the SQL Server is deployed.                                                         | `string`  | N/A         |
| `connection_policy`        | Defines the connection policy for the SQL Server.                                                               | `string`  | `"Default"` |
| `mssqlserver_login_name`   | Specifies the login name for SQL Server authentication.                                                         | `string`  | N/A         |
| `location_override`        | Overrides the location of the SQL Server.                                                                       | `string`  | `""`        |
| `name_override`            | Forces a custom name for the SQL Server resource. Typically should not be used.                                 | `string`  | `""`        |
| `whitelist_azure_services` | Adds a firewall rule that allows Azure services to access the SQL server. Mainly used for Confluent Connectors. | `boolean` | `false`     |

### Notes:
* The server will automatically be configured with a firewall rule that allows all Azure services to communicate with the SQL server. This is done to allow Confluent Sink connectors to communicate with the Servers databases.