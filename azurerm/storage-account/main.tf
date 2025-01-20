locals {
  standard_name = "${var.name}${var.environment}"
  loc           = var.location_override != "" ? var.location_override : var.resource_group.location
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.name_override != "" ? var.name_override : local.standard_name
  resource_group_name      = var.resource_group.name
  location                 = local.loc
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind

  is_hns_enabled = var.is_data_lake ? true : false
}

//resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
//  count = var.is_data_lake ? 1 : 0
//
//  name               = "${azurerm_storage_account.storage_account.name}-data-lake"
//  storage_account_id = azurerm_storage_account.storage_account.id
//
//  properties = var.data_lake_properties
//}

// NOTE: This approach does not allow the use of the azure data lake properties argument
//       at time of writing, we think that it is not neccessary to support this,
//       but it is neccessary in the future 

resource "azurerm_storage_container" "container" {
  for_each             = { for container in var.containers : container.name => container }
  storage_account_name = azurerm_storage_account.storage_account.name

  name                  = each.value.name
  container_access_type = can(each.value.container_access_type) ? each.value.container_access_type : "private"
}
