# output "acr_login_server" {
#   value = azurerm_container_registry.acr.login_server
# }

# output "acr_name" {
#   value = azurerm_container_registry.acr.name
# }

output "keyvault_name" {
  value = azurerm_key_vault.platform.name
}

output "keyvault_id" {
  value = azurerm_key_vault.platform.id
}

output "keyvault_uri" {
  value = azurerm_key_vault.platform.vault_uri
}