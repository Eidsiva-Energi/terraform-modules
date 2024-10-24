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
  version                      = "12.0"
  administrator_login          = var.mssqlserver_login_name
  administrator_login_password = local.login_password
  minimum_tls_version          = "1.2"

  connection_policy = var.connection_policy

  identity {
    type = "SystemAssigned"
  }
}


## Firewall rules

locals {
  # Define your firewall rules with multiple IP addresses for each cluster
  firewall_rules = {
    "eidsivaenergi_test" = {
      environment = "test"
      name        = "EidsivaEnergiTestConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30", # This indicates a range from 4.235.113.96 to 4.235.113.99
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30", # This indicates a range from 51.120.10.240 to 51.120.10.243
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30", # This indicates a range from 51.120.244.188 to 51.120.244.191
        "51.120.250.71/32"
      ]

    }
    "eidsivaenergi_prod" = {
      environment = "prod"
      name        = "EidsivaEnergiProdConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30",
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30",
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30",
        "51.120.250.71/32"
      ]

    }
    "bredband_test" = {
      environment = "test"
      name        = "BredbandTestConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30",
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30",
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30",
        "51.120.250.71/32"
      ]

    }
    "bredband_prod" = {
      environment = "prod"
      name        = "BredbandProdConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30",
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30",
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30",
        "51.120.250.71/32"
      ]
    }
    "bio_test" = {
      environment = "test"
      name        = "BioTestConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30",
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30",
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30",
        "51.120.250.71/32"
      ]
    }
    "bio_prod" = {
      environment = "prod"
      name        = "BioProdConfluentCluster"
      ip_addresses = [
        "4.235.113.90/32",
        "4.235.113.92/32",
        "4.235.113.96/30",
        "20.251.169.62/32",
        "51.120.8.201/32",
        "51.120.10.240/30",
        "51.120.12.2/32",
        "51.120.50.206/32",
        "51.120.240.71/32",
        "51.120.242.243/32",
        "51.120.244.188/30",
        "51.120.250.71/32"
      ]
    }
  }
}

resource "azurerm_mssql_firewall_rule" "eidsivaenergi_test_confluent" {
  count            = var.environment == "test" && var.organization == "eidsivaenergi" ? length(local.firewall_rules["eidsivaenergi_test"].ip_addresses) : 0
  name             = "EidsivaEnergiTestConfluentCluster-${element(local.firewall_rules["eidsivaenergi_test"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["eidsivaenergi_test"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["eidsivaenergi_test"].ip_addresses, count.index)
}

resource "azurerm_mssql_firewall_rule" "eidsivaenergi_prod_confluent" {
  count            = var.environment == "prod" && var.organization == "eidsivaenergi" ? length(local.firewall_rules["eidsivaenergi_prod"].ip_addresses) : 0
  name             = "EidsivaEnergiProdConfluentCluster-${element(local.firewall_rules["eidsivaenergi_prod"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["eidsivaenergi_prod"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["eidsivaenergi_prod"].ip_addresses, count.index)
}

resource "azurerm_mssql_firewall_rule" "bredband_test_confluent" {
  count            = var.environment == "test" && var.organization == "bredband" ? length(local.firewall_rules["bredband_test"].ip_addresses) : 0
  name             = "BredbandTestConfluentCluster-${element(local.firewall_rules["bredband_test"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["bredband_test"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["bredband_test"].ip_addresses, count.index)
}

resource "azurerm_mssql_firewall_rule" "bredband_prod_confluent" {
  count            = var.environment == "prod" && var.organization == "bredband" ? length(local.firewall_rules["bredband_prod"].ip_addresses) : 0
  name             = "BredbandProdConfluentCluster-${element(local.firewall_rules["bredband_prod"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["bredband_prod"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["bredband_prod"].ip_addresses, count.index)
}

resource "azurerm_mssql_firewall_rule" "bio_test_confluent" {
  count            = var.environment == "test" && var.organization == "bio" ? length(local.firewall_rules["bio_test"].ip_addresses) : 0
  name             = "BioTestConfluentCluster-${element(local.firewall_rules["bio_test"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["bio_test"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["bio_test"].ip_addresses, count.index)
}

resource "azurerm_mssql_firewall_rule" "bio_prod_confluent" {
  count            = var.environment == "prod" && var.organization == "bio" ? length(local.firewall_rules["bio_prod"].ip_addresses) : 0
  name             = "BioProdConfluentCluster-${element(local.firewall_rules["bio_prod"].ip_addresses, count.index)}"
  server_id        = azurerm_mssql_server.mssql_server.id
  start_ip_address = element(local.firewall_rules["bio_prod"].ip_addresses, count.index)
  end_ip_address   = element(local.firewall_rules["bio_prod"].ip_addresses, count.index)
}
