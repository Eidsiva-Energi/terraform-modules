locals {
  standard_name = "${var.name}-${var.environment}"
  location      = var.location_override != "" ? var.location_override : var.resource_group.location
}

resource "azurerm_sql_server" "sqlserver" {
  name                         = var.name_override != "" ? var.name_override : local.standard_name
  resource_group_name          = var.resource_group.name
  location                     = local.location
  version                      = var.server_version
  administrator_login          = var.sqlserver_login_name
  administrator_login_password = var.sqlserver_login_password
  identity {
    type = "SystemAssigned"
  }
  connection_policy = var.connection_policy
}

resource "azurerm_sql_firewall_rule" "allow_all_windows_azure_ips" {
  name                = "AllowAllWindowsAzureIps"
  resource_group_name = var.resource_group.name
  server_name         = azurerm_sql_server.sqlserver.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

