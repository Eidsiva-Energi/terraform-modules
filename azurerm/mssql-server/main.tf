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
  # Define your firewall rules with individual IP addresses
  firewall_rules = {
    "eidsivaenergi_test" = {
      environment = "test"
      name        = "EidsivaEnergiTestConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
      ]
    }
    "eidsivaenergi_prod" = {
      environment = "prod"
      name        = "EidsivaEnergiProdConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
      ]
    }
    "bredband_test" = {
      environment = "test"
      name        = "BredbandTestConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
      ]
    }
    "bredband_prod" = {
      environment = "prod"
      name        = "BredbandProdConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
      ]
    }
    "bio_test" = {
      environment = "test"
      name        = "BioTestConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
      ]
    }
    "bio_prod" = {
      environment = "prod"
      name        = "BioProdConfluentCluster"
      ip_addresses = [
        "4.231.52.16", "4.231.52.17", "4.231.52.18", "4.231.52.19", "4.231.52.20",
        "4.231.52.21", "4.231.52.22", "4.231.52.23", "4.231.52.24", "4.231.52.25",
        "4.231.52.26", "4.231.52.27", "4.231.52.28", "4.231.52.29", "4.231.52.30",
        "4.231.52.31", "4.231.56.39", "20.86.26.16", "20.86.26.17", "20.86.63.60",
        "20.86.63.61", "20.86.63.65", "20.86.63.72", "20.224.64.147", "74.234.169.181",
        "74.234.205.112", "74.234.205.113", "74.234.205.114", "74.234.205.115",
        "74.234.205.116", "74.234.205.117", "74.234.205.118", "74.234.205.119",
        "74.234.205.120", "74.234.205.121", "74.234.205.122", "74.234.205.123",
        "74.234.205.124", "74.234.205.125", "74.234.205.126", "74.234.205.127",
        "74.234.243.134", "74.234.243.135", "74.234.243.161", "74.234.243.200",
        "74.234.243.201", "74.234.243.249", "74.234.250.100", "74.234.250.101",
        "74.234.250.148", "74.234.250.149", "74.234.250.168", "74.234.250.184",
        "74.234.253.144", "74.234.253.145", "74.234.253.146", "74.234.253.147",
        "74.234.253.148", "74.234.253.149", "74.234.253.150", "74.234.253.151",
        "74.234.253.152", "74.234.253.153", "74.234.253.154", "74.234.253.155",
        "74.234.253.156", "74.234.253.157", "74.234.253.158", "74.234.253.159"
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
