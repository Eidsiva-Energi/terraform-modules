locals {
  standard_name = "${var.name}${var.environment}"
  cosmosdb      = concat(azurerm_cosmosdb_account.db.*, [null])[0]
}

resource "azurerm_cosmosdb_account" "db" {
  count               = var.enabled ? 1 : 0
  name                = var.name_override != "" ? var.name_override : local.standard_name
  location            = var.resource_group.location
  resource_group_name = var.resource_group.name
  offer_type          = var.offer_type
  kind                = var.kind

  automatic_failover_enabled = var.enable_automatic_failover
  default_identity_type      = var.default_identity_type

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.failover_location
    failover_priority = var.failover_priority
  }

  dynamic "backup" {
    for_each = var.backup_type == null ? [] : [1]
    content {
      type = var.backup_type
    }
  }

  dynamic "capabilities" {
    for_each = var.enable_table_api == false ? [] : [1]
    content {
      name = "EnableTable"
    }
  }

  dynamic "capabilities" {
    for_each = var.allow_self_serve_upgrade_to_mongo36 == false ? [] : [1]
    content {
      name = "AllowSelfServeUpgradeToMongo36"
    }
  }

  dynamic "capabilities" {
    for_each = var.disable_rate_limiting_responses == false ? [] : [1]
    content {
      name = "DisableRateLimitingResponses"
    }
  }

  dynamic "capabilities" {
    for_each = var.enable_serverless == false ? [] : [1]
    content {
      name = "EnableServerless"
    }
  }
}

