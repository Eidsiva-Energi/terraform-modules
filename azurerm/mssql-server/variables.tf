variable "name" {
}

variable "server_version" {
  default = "12.0"
}

variable "environment" {
}

variable "organization" {
}

variable "resource_group" {
}

variable "connection_policy" {
  default = "Default"
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

variable "firewall_whitelist_azure_services" {
  description = "Set this to true to allow all Azure services to access the database server. This can for example be used to allow Confluent Cloud Connectors to access the database server."
  default     = false
}
