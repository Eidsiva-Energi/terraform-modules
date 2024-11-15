resource "random_password" "password" {
  length  = 32
  special = false
}

locals {
  standard_name  = "${var.name}-${var.environment}"
  loc            = var.location_override != "" ? var.location_override : var.resource_group.location
  login_password = random_password.password.result
}

resource "azurerm_mssql_server" "mssql_server" {
  name                         = var.name_override != "" ? var.name_override : local.standard_name
  resource_group_name          = var.resource_group.name
  location                     = local.loc
  version                      = var.server_version
  administrator_login          = var.mssqlserver_login_name
  administrator_login_password = local.login_password
  minimum_tls_version          = "1.2"

  connection_policy = var.connection_policy

  identity {
    type = "SystemAssigned"
  }
}


## Firewall rules
resource "azurerm_mssql_firewall_rule" "whitelist_azure_services" {
  count            = var.whitelist_azure_services ? 1 : 0
  name             = "Allow access to Azure services"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
