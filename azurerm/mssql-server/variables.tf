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

variable "mssqlserver_login_password" {
}

variable "location_override" {
  default = ""
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}
