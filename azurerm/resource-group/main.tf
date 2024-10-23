locals {
  standard_name = "${var.name}-${var.environment}"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.standard_name
  location = var.location
}
