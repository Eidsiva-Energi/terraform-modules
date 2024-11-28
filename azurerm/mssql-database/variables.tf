variable "name" {}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. "
  default     = ""
}

variable "resource_group" {
  description = "(Required) The resource group where the extended auditing policy storage account is created."
}

variable "retention_policy_in_days" {
  description = "(Optional) Specifies the number of days that logs will be retained. Changing this forces a new resource."
  default     = 180
}

variable "environment" {}

variable "location_override" {
  description = "(Optional) overrides the Azure location inherrited from the resource group. Must be a valid Azure location."
  default     = ""

  validation {
    condition     = can(regex("^(${replace(replace(file("${path.module}/azure-locations.txt"), "\r\n", "|"), "\n", "|")})$", var.location_override))
    error_message = "Invalid Azure location. Value must be one of the following: [${replace(replace(file("${path.module}/azure-locations.txt"), "\r\n", ", "), "\n", ", ")}]"
  }
}

variable "azurerm_mssql_server" {
  description = "(Required) Reference to an Azure SQL Server."
}

variable "sku_name" {
  description = "(Optional) Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2, DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource."
  default     = "GP_S_Gen5_2"

  validation {
    condition     = can(regex("^(GP_S_Gen5_2|HS_Gen4_1|BC_Gen5_2|ElasticPool|Basic|S0|P2|DW100c|DS100)$", var.sku_name))
    error_message = "Invalid SKU name. Value must be one of the following: GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2, DW100c, DS100."
  }
}

variable "short_term_retention_policy_in_days" {
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database#short_term_retention_policy
  description = "(Optional) Point In Time Restore configuration. Value has to be between 1 and 35."
  default     = "7"

  validation {
    condition     = var.short_term_retention_policy_in_days >= 1 && var.short_term_retention_policy_in_days <= 35
    error_message = "Number of retention days has to be between 1 and 35."
  }
}

variable "auto_pause_delay_in_minutes" {
  description = "(Optional) Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases. Value should be in increments of 10, e.g. `10`, `20`, `30`, etc."
  default     = 60
  type        = number
}

variable "collation" {
  description = "(Optional) Specifies the collation of the database. Changing this forces a new resource to be created."
  default     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

variable "max_size_gb" {
  description = "(Optional) The max size of the database in gigabytes."
  default     = null
}

variable "min_capacity" {
  description = "(Optional) Minimal capacity that database will always have allocated, if not paused. This property is only settable for General Purpose Serverless databases."
  default     = 0.5
}

variable "weekly_backup_retention_period" {
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database#long_term_retention_policy
  description = "(Optional) The weekly retention policy for an LTR backup in an ISO 8601 format. Valid value is between 1 to 520 weeks. e.g. P1Y, P1M, P1W or P7D. This property is ignored if auto-pause is enabled in serverless mode (sku_name=GP_S_Gen5_2). "
  default     = "P4W"
}
