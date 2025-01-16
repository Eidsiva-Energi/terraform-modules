variable "name" {
  type = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name))
    error_message = "${var.name} is an invalid name. The name must be between 3 and 24 characters long and contain only lowercase letters and numbers."
  }
}

variable "name_override" {
  default = ""
  type    = string

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.name_override))
    error_message = "${var.name_override} is an invalid name. The name must be between 3 and 24 characters long and contain only lowercase letters and numbers."
  }
}

variable "location_override" {
  default = ""
  type    = string

  validation {
    condition     = var.location_override == "" || can(regex("^(${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", "|"), "\n", "|")})$", var.location_override))
    error_message = "Invalid Azure location. Value must be one of the following: [${replace(replace(file("${path.module}/../allowed-azure-locations.txt"), "\r\n", ", "), "\n", ", ")}]"
  }
}

variable "resource_group" {
  type = object({
    name     = string
    id       = string
    location = string
  })
}

variable "environment" {
  type = string
}

variable "account_tier" {
  default = "Standard"
  type    = string

  validation {
    condition     = can(regex("^(Standard|Premium)$", var.account_tier))
    error_message = "'${var.account_tier}' is an invalid account tier. Value must be one of the following: [Standard, Premium]"
  }
}

variable "account_replication_type" {
  type = string

  validation {
    condition     = can(regex("^(LRS|GRS|RAGRS|ZRS)$", var.account_replication_type))
    error_message = "'${var.account_replication_type}' is an invalid account replication type. Value must be one of the following: [LRS, GRS, RAGRS, ZRS]"
  }
}

variable "account_kind" {
  default = "StorageV2"
  type    = string

  validation {
    condition     = can(regex("^(BlobStorage|BlockBlocStorage|FileStorage|Storage|StorageV2)$", var.account_kind))
    error_message = "'${var.account_kind}' is an invalid account kind. Value must be one of the following: [BlobStorage, BlockBlocStorage, FileStorage, Storage, StorageV2]"
  }
}

variable "data_lake_properties" {
  default = {}
  type    = object({})
}

variable "is_data_lake" {
  default = false
  type    = bool
}
