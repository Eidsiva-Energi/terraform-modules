locals {
  standard_name = "${var.name}-${var.environment}"
  loc           = var.location_override != "" ? var.location_override : var.resource_group.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name_override != "" ? var.name_override : local.standard_name
  resource_group_name      = var.resource_group.name
  location                 = local.loc
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
  name               = "${azurerm_storage_account.storage_account.name}-data-lake"
  storage_account_id = azurerm_storage_account.storage_account.id

  properties = var.properties
}
