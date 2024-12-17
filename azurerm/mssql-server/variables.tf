variable "name" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.name)) && !can(regex("--", var.name))
    error_message = "Name must only contain lowercase letters, numbers, and hyphens. It cannot start with a hyphen and must not contain two hyphens in a row."
  }
  validation {
    condition     = length(var.name) <= 63 && length(var.name) >= 1
    error_message = "Name has wrong length, it must be between 1 and 63 characters long."
  }
}

variable "server_version" {
  default = "12.0"
  type    = string

  validation {
    condition     = can(regex("^(12.0|2.0)$", var.server_version))
    error_message = "${var.server_version} is an invalid server version. Value must be one of the following: [2.0 (for a v11 server), 12.0 (for a v12 server)]"
  }
}

variable "environment" {
  type = string
}

variable "organization" {
  type = string
}

variable "resource_group" {
  type = object({
    name        = string
    environment = string
    location    = string
  })
}

variable "connection_policy" {
  default = "Default"
  type    = string

  validation {
    condition     = can(regex("^(Default|Proxy|Redirect)$", var.connection_policy))
    error_message = "'${var.connection_policy}' is an invalid connection policy. Value must be one of the following: [Default, Proxy, Redirect]"
  }
}

variable "mssqlserver_login_name" {
  type = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_-]*$", var.mssqlserver_login_name))
    error_message = "mssqlserver_login_name must start with a letter and contain only letters, numbers, dashes, and underscores."
  }

  validation {
    condition     = !can(regex("^(admin|administrator|sa|root|dbmanager|loginmanager|dbo|guest|public)$", lower(var.mssqlserver_login_name)))
    error_message = "mssqlserver_login_name must not be a commonly used name such as 'admin, administrator, sa, root, public, etc.'"
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

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
  type        = string

  validation {
    condition     = var.name_override == "" || (can(regex("^[^<>*%&:\\/?]+$", var.name_override)) && !can(regex("[. ]$", var.name_override)))
    error_message = "Invalid name_override. Name must not contain any of the following characters: <, >, *, %, &, :, \\, /, ?, and it must not end with a period or space"
  }
  validation {
    condition     = var.name_override == "" || length(var.name_override) <= 128 && length(var.name_override) >= 1
    error_message = "name_override has wrong length, it must be between 1 and 128 characters long."
  }
}

variable "whitelist_azure_services" {
  description = "Set this to true to allow all Azure services to access the database server. This can for example be used to allow Confluent Cloud Connectors to access the database server."
  default     = false
  type        = bool
}
