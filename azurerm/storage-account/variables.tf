variable "name" {
  type        = string
  description = "The name of the storage account. The final name will be suffixed with the name of the environment. Changing this forces a new resource to be created."

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "${var.name} is an invalid name. The name must be between 3 and 24 characters long and contain only lowercase letters and numbers."
  }
}

variable "name_override" {
  default     = ""
  type        = string
  description = "Forces a specific name for the storage account. Bypasses the suffixing of the environment name. Changing this forces a new resource to be created."

  validation {
    condition     = var.name_override == "" || can(regex("^[a-z0-9]{3,24}$", var.name_override))
    error_message = "${var.name_override} is an invalid name. The name must be between 3 and 24 characters long and contain only lowercase letters and numbers."
  }
}

variable "resource_group" {
  type = object({
    name     = string
    id       = string
    location = string
  })
  description = "The resource group in which to create the storage account."
}

variable "location_override" {
  default     = ""
  type        = string
  description = "Forces a specific Azure region for the storage account. By default, the region of the resource group will be used."

  validation {
    condition     = var.location_override == "" || can(regex("^(${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", "|"), "\n", "|")})$", var.location_override))
    error_message = "Invalid Azure location. Value must be one of the following: [${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", ", "), "\n", ", ")}]"
  }
}

variable "environment" {
  type        = string
  description = "The environment in which the storage account is being created (e.g. dev, test, prod). This will be suffixed to the name of the storage account."
}

variable "account_tier" {
  default     = "Standard"
  type        = string
  description = "The performance tier of the storage account. Can be either Standard or Premium."

  validation {
    condition     = can(regex("^(Standard|Premium)$", var.account_tier))
    error_message = "'${var.account_tier}' is an invalid account tier. Value must be one of the following: [Standard, Premium]"
  }
}

variable "account_replication_type" {
  type        = string
  description = "The replication type of the storage account. Can be either LRS, GRS, RAGRS, or ZRS."

  validation {
    condition     = can(regex("^(LRS|GRS|RAGRS|ZRS)$", var.account_replication_type))
    error_message = "'${var.account_replication_type}' is an invalid account replication type. Value must be one of the following: [LRS, GRS, RAGRS, ZRS]"
  }
}

variable "account_kind" {
  default     = "StorageV2"
  type        = string
  description = "The kind of storage account. Can be either BlobStorage, BlockBlocStorage, FileStorage, Storage, or StorageV2. By default, StorageV2 is used. BlockBlobStorage and FileStorage require that the account tier is set to Premium."

  validation {
    condition     = can(regex("^(BlobStorage|BlockBlocStorage|FileStorage|Storage|StorageV2)$", var.account_kind))
    error_message = "'${var.account_kind}' is an invalid account kind. Value must be one of the following: [BlobStorage, BlockBlocStorage, FileStorage, Storage, StorageV2]"
  }
}

variable "is_data_lake" {
  default     = false
  type        = bool
  description = "Whether or not to create a Data Lake Gen2 filesystem in the storage account."
}

variable "data_lake_properties" {
  default     = {}
  type        = object({})
  description = "The properties to apply to the Data Lake Gen2 filesystem. Only used if is_data_lake is set to true."
}

variable "container_names" {
  default     = []
  type        = list(string)
  description = "The names of the containers to create in the storage account."
}

variable "data_lake_container_properties" {
  default     = []
  type        = list(object({}))
  description = "The properties to apply to the Data Lake Gen2 filesystem containers. Only used if is_data_lake is set to true."
}
