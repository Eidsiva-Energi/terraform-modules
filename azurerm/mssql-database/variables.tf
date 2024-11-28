variable "name" {
  validation {
    condition     = var.name == "" || (can(regex("^[^<>*%&:\\/?]+$", var.name)) && length(var.name) <= 128 && length(var.name) >= 1)
    error_message = "Invalid name. Name must not contain any of the following characters: <, >, *, %, &, :, \\, /, ?. Name must be between 1 and 128 characters long."
  }
}

variable "name_override" {
  description = "Set this to force a name of the resource. Should normally not be used. By default, the name is generated as 'name-environment'."
  default     = ""

  validation {
    condition     = var.name_override == "" || (can(regex("^[^<>*%&:\\/?]+$", var.name_override)) && !can(regex("[. ]$", var.name_override)) && length(var.name_override) <= 128 && length(var.name_override) >= 1)
    error_message = "Invalid name_override. Name must not contain any of the following characters: <, >, *, %, &, :, \\, /, ?, and it must not end with a period or space. Name must be between 1 and 128 characters long."
  }
}

variable "resource_group" {
  description = "(Required) The resource group where the extended auditing policy storage account is created."
}

variable "environment" {}

variable "location_override" {
  description = "(Optional) overrides the Azure location inherrited from the resource group. Must be a valid Azure location."
  default     = ""

  validation {
    condition     = var.location_override == "" || can(regex("^(${replace(replace(file("${path.module}/azure-locations.txt"), "\r\n", "|"), "\n", "|")})$", var.location_override))
    error_message = "Invalid Azure location. Value must be one of the following: [${replace(replace(file("${path.module}/azure-locations.txt"), "\r\n", ", "), "\n", ", ")}]"
  }
}

variable "azurerm_mssql_server" {
  description = "(Required) Reference to an Azure SQL Server."
}

variable "sku_name" {
  description = "(Optional) Specifies the name of the SKU used by the database. For example, GP_S_Gen5_2, HS_Gen4_1, BC_Gen5_2, ElasticPool, Basic, S0, P2, DW100c, DS100. Changing this from the HyperScale service tier to another service tier will create a new resource. Use 'az sql db list-editions --location westeurope -o table' to see all availible SKUs"
  default     = "GP_S_Gen5_2"

  validation {
    condition     = var.sku_name == "" || can(regex("^(${replace(replace(file("${path.module}/db-skus-westeurope.txt"), "\r\n", "|"), "\n", "|")})$", var.sku_name))
    error_message = "Invalid SKU name. Value must be one of the following: [${replace(replace(file("${path.module}/db-skus-westeurope.txt"), "\r\n", ", "), "\n", ", ")}]"
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
  description = "(Optional) Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. This property is only settable for General Purpose Serverless databases. Value should be in increments of 10, e.g. `10`, `20`, `30`, etc. Maximum is 10080 (seven days)."
  default     = 60
  type        = number

  validation {
    condition     = var.auto_pause_delay_in_minutes == -1 || (var.auto_pause_delay_in_minutes >= 15 && var.auto_pause_delay_in_minutes <= 10080)
    error_message = "Invalid Auto Pause Delay value. Value should be either -1 or between 15 and 10080 (seven days)."
  }
}

variable "collation" {
  //TODO: Sjekk om det er nødvendig å lage validation for collation
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
