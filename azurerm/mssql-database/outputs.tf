output "azurerm_mssql_database" {
  value     = length(azurerm_mssql_database.db) > 0 ? azurerm_mssql_database.db[0] : null
  sensitive = true
}
