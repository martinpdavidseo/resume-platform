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

  scope                = azurerm_key_vault.platform.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_user_assigned_identity" "platform" {
  location            = azurerm_resource_group.platform.location
  name                = "${var.project_name}-${var.environment}-mi-platform"
  resource_group_name = azurerm_resource_group.platform.name
}

resource "azurerm_role_assignment" "keyvault_reader" {

  scope                = azurerm_key_vault.platform.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.platform.id
}

resource "azurerm_log_analytics_workspace" "platform" {
  name                = "${var.project_name}-${var.environment}-log-analytics"
  location            = azurerm_resource_group.platform.location
  resource_group_name = azurerm_resource_group.platform.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "platform" {
  name                       = "${var.project_name}-${var.environment}-container-app-env"
  location                   = azurerm_resource_group.platform.location
  resource_group_name        = azurerm_resource_group.platform.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.platform.id
}

# resource "azurerm_container_app" "Home" {

#   name                         = "${var.project_name}-${var.environment}-home"
#   resource_group_name          = azurerm_resource_group.platform.name
#   container_app_environment_id = azurerm_container_app_environment.platform.id
#   revision_mode = "Single"
#   identity {
#     type = "UserAssigned"

#     identity_ids = [
#       azurerm_user_assigned_identity.platform.id
#     ]
#   }

#   template {
#     container {
#       name   = "home"
#       image  = "resumedevacr001.azurecr.io/home-api:v1"

#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#   }
# }