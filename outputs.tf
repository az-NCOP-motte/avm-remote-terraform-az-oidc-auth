output "azurerm_client_config.current.object_id" {
  value = data.azurerm_client_config.current.object_id
}

output "azurerm_client_config.current.subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "azuread_service_principal_clientID" {
  value = var.devops_principle_client_id
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME" {
  value = azurerm_storage_container.tf_state.name
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_KEY_NAME" {
  value = azurerm_storage_blob.tf_state.name
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.tf_state.name
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  value = azurerm_resource_group.TODO.name
}

output "APP_CONFIG_ENDPOINT" {
  value = azurerm_app_configuration.TODO.endpoint
}