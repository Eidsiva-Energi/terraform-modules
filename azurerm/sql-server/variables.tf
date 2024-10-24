variable "name" {
}

variable "server_version" {
  default = "12.0"
}

variable "environment" {
}

variable "resource_group" {
}

variable "connection_policy" {
  default = "Default"
}

variable "sqlserver_login_name" {
}

variable "sqlserver_login_password" {
}

variable "location_override" {
  default = ""
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}
