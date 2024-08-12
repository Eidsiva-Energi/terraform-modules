variable "name" {
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}

variable "environment" {
}

variable "resource_group" {
}

variable "offer_type" {
  default = "Standard"
}

variable "kind" {
  default = "GlobalDocumentDB"
}

variable "enable_automatic_failover" {
  default = false
}

variable "consistency_level" {
}

variable "failover_location" {
}

variable "failover_priority" {
  default = 0
}

variable "cosmos_db_account_name_canonical_name" {
}

variable "system_name" {
}

variable "enabled" {
  default = true
}

variable "enable_table_api" {
  default = false
}

variable "allow_self_serve_upgrade_to_mongo36" {
  default = false
}

variable "disable_rate_limiting_responses" {
  default = false
}

variable "enable_serverless" {
  default = false
}
variable "backup_type" {
  description = "Should be Periodic or Continuous. If no value is provided, defaults to Periodic"
  default     = null
}

variable "default_identity_type" {
  default = "FirstPartyIdentity"
}
