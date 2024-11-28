locals {
  standard_name = "${var.name}-${var.environment}"
  loc           = var.location_override != "" ? var.location_override : var.resource_group.location
}

resource "azurerm_mssql_database" "mssqldatabase" {
  name                        = var.name_override != "" ? var.name_override : local.standard_name
  server_id                   = var.azurerm_mssql_server.id
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  collation                   = var.collation
  max_size_gb                 = var.max_size_gb
  min_capacity                = var.min_capacity
  sku_name                    = var.sku_name

  short_term_retention_policy {
    retention_days = var.short_term_retention_policy_in_days
  }

  # long_term_retention_policy is not supported if auto-pause is enabled
  # long_term_retention_policy sequires a serverless sku, indicated by the presence of "_S_" in the sku_name
  dynamic "long_term_retention_policy" {

    for_each = can(regex(".._S_", var.sku_name)) && var.auto_pause_delay_in_minutes != -1 ? [] : [1]
    content {
      weekly_retention = var.weekly_backup_retention_period
    }
  }
}
