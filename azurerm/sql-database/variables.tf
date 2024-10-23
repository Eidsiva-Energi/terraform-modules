variable "database_name" {
}

variable "resource_group" {
}

variable "sql_server" {
}

variable "environment" {
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}

variable "requested_service_objective_name" {
  default = "S3"
}

variable "edition" {
  default = "Standard"
}

variable "create_mode" {
  default = "Default"
}

variable "sqldatabase_administrator_login" {
  default     = ""
  description = "The SQL database admin must be manually created outside of Terraform. If not set, the SQL Server admin will be used."
}

variable "sqldatabase_administrator_login_password" {
  default     = ""
  description = "The SQL database admin must be manually created outside of Terraform. If not set, the SQL Server admin will be used."
}

variable "location_override" {
  default = ""
}

variable "collation" {
  default = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

variable "enabled" {
  default     = true
  type        = bool
  description = "This can be used to add SQL Server Database only to some evironments. Eg:  enabled = var.environment != \"prod\""
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "{environment=dev}"
}
