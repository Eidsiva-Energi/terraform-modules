locals {
  standard_name  = "${var.database_name}-${var.environment}"
  loc            = var.location_override != "" ? var.location_override : var.resource_group.location
  admin_login    = var.sqldatabase_administrator_login != "" ? var.sqldatabase_administrator_login : var.sql_server.administrator_login
  admin_password = var.sqldatabase_administrator_login_password != "" ? var.sqldatabase_administrator_login_password : var.sql_server.administrator_login_password
}

resource "azurerm_sql_database" "db" {
  count                            = var.enabled ? 1 : 0
  name                             = var.name_override != "" ? var.name_override : local.standard_name
  resource_group_name              = var.resource_group.name
  location                         = local.loc
  server_name                      = var.sql_server.name
  edition                          = var.edition
  requested_service_objective_name = var.requested_service_objective_name
  create_mode                      = var.create_mode
  collation                        = var.collation
  tags                             = var.tags
}
