output "azurerm_sql_database" {
  value     = length(azurerm_sql_database.db) > 0 ? azurerm_sql_database.db[0] : null
  sensitive = true
}
