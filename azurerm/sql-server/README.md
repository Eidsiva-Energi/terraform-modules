### Variables
| **Variable**                | **Description**                               | **Type**   | **Default**   |
|-----------------------------|-----------------------------------------------|------------|---------------|
| `name`                      | The name of the SQL Server.                   | `string`   | N/A           |
| `version`                   | The version of the SQL Server.                | `string`   | `12.0`        |
| `environment`               | The environment where the SQL Server is used. | `string`   | N/A           |
| `resource_group`            | The resource group for the SQL Server.        | `string`   | N/A           |
| `connection_policy`         | The connection policy for the SQL Server.     | `string`   | `Default`     |
| `sqlserver_login_name`      | The login name for the SQL Server.            | `string`   | N/A           |
| `sqlserver_login_password`  | The login password for the SQL Server.        | `string`   | N/A           |
| `location_override`         | An optional location override for resources.  | `string`   | `""`          |