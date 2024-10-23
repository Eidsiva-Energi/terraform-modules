output "azurerm_sql_database" {
  value     = length(azurerm_sql_database.db) > 0 ? azurerm_sql_database.db[0] : null
  sensitive = true
}

output "connection_host" {
  value     = length(azurerm_sql_database.db) > 0 ? azurerm_sql_database.db[0].fully_qualified_domain_name : null
  sensitive = true
}

output "connection_port" {
  value     = length(azurerm_sql_database.db) > 0 ? 1433 : null
  sensitive = true
}

output "connection_user" {
  value     = length(azurerm_sql_database.db) > 0 ? azurerm_sql_database.db[0].administrator_login : null
  sensitive = true
}

output "connection_user_password" {
  value     = length(azurerm_sql_database.db) > 0 ? azurerm_sql_database.db[0].administrator_login_password : null
  sensitive = true
}
