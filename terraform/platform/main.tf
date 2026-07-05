resource "azurerm_resource_group" "platform" {
  name     = "${var.project_name}-${var.environment}-rg-platform"
  location = var.location
}

resource "azurerm_container_registry" "platform" {
  name                = "${var.project_name}${var.environment}acr001"
  resource_group_name = azurerm_resource_group.platform.name
  location            = azurerm_resource_group.platform.location
  sku                 = "Basic"
  admin_enabled       = false
}