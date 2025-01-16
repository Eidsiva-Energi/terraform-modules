variable "name" {
  type = string
}

variable "name_override" {
  default = ""
  type    = string
}

variable "location_override" {
  default = ""
  type    = string
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

variable "properties" {
  default = {}
  type    = object({})
}

variable "is_data_lake" {
  default = false
  type    = bool
}
