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

resource "azurerm_key_vault" "platform" {
  name                = "${var.project_name}-${var.environment}-kv-001"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name

  tenant_id = data.azurerm_client_config.current.tenant_id
  sku_name  = "standard"

  rbac_authorization_enabled = true

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  public_network_access_enabled = true
}

resource "azurerm_role_assignment" "keyvault_admin" {

  scope = azurerm_key_vault.platform.id
  role_definition_name = "Key Vault Administrator"
  principal_id = data.azurerm_client_config.current.object_id

}