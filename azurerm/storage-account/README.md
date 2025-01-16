### Storage Account Configuration Variables

This section provides details about the configurable variables for setting up a Storage Account resource in Azure. Variables without a default value are required.

| **Variable**               | **Description**                                                                                  | **Type**     | **Default** |
|----------------------------|--------------------------------------------------------------------------------------------------|--------------|-------------|
| `name`                     | The name of the Storage Account. Unless the override is used, the name will have the environment name tagged on at the end of the specified name.  |`string`| N/A |
| `name_override`            | Forces a custom name for the Storage Account. Should typically not be used.                      | `string`     | ""          |
| `resource_group`           | The resource group in which the Storage Account is deployed.                                     | `object({name<string>, id<string>, location<string>})`         | N/A |
| `location_override`        | Forces the Storage Account to be located in the specified Azure location. By default it will be located in the same region as its Resource Group.  |`string`| ""  |
| `environment`              | The environment the Storage Account runs in (e.g., dev, prod).                                   | `string`     | N/A         |
| `account_tier`             | Sets the Tier used by the Storage Account. Can be either `"Standard"` or `"Premium"`             | `string`     | `"Standard"`|
| `account_replication_type` | Sets the replication type used by the Storage Account.                                           | `string`     | N/A         |
| `account_kind`             | Sets what Kind of Storage Account this will be. Can be `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage`, or `StorageV2` | `string` | `"StorageV2"` |
| `is_data_lake`             | Sets whether or not this Storage Account should be a Data Lake                                   | `boolean`    | `false`     |
| `data_lake_properties`     | A mapping of key to Base54-Encoded Values which will be assigneded to the Data Lake File System. | `object({key<string>, ... })` | `object({})` |