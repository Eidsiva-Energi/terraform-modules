variable "name" {
}

variable "server_version" {
  default = "12.0"

  validation {
    condition     = can(regex("^(12.0|2.0)$", var.server_version))
    error_message = "${var.server_version} is an invalid server version. Value must be one of the following: [2.0 (for a v11 server), 12.0 (for a v12 server)]"
  }
}

variable "environment" {
}

variable "organization" {
}

variable "resource_group" {
}

variable "connection_policy" {
  default = "Default"

  validation {
    condition     = can(regex("^(Default|Proxy|Redirect)$", var.connection_policy))
    error_message = "'${var.connection_policy}' is an invalid connection policy. Value must be one of the following: [Default, Proxy, Redirect]"
  }
}

variable "mssqlserver_login_name" {
}

variable "location_override" {
  default = ""
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}

variable "whitelist_azure_services" {
  description = "Set this to true to allow all Azure services to access the database server. This can for example be used to allow Confluent Cloud Connectors to access the database server."
  default     = false
}
