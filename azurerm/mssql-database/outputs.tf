output "azurerm_mssql_database" {
  value     = length(azurerm_mssql_database.mssqldatabase) > 0 ? azurerm_mssql_database.mssqldatabase[0] : null
  sensitive = true
}
