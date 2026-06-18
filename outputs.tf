output "azapi_client_config_subscription_id" {
  value = data.azapi_client_config.current.subscription_id
}

output "azapi_client_config_object_id" {
  value = data.azapi_client_config.current.tenant_id
}

output "azuread_service_principal_client_id" {
  value = data.azuread_service_principal.devops_sp.client_id
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME" {
  value = azurerm_storage_container.tf_state.name
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAME" {
  value = azurerm_storage_account.tf_state.name
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  value = module.az-environment-resourcegroup.name
}

output "APP_CONFIG_ENDPOINT" {
  value = azurerm_app_configuration.TODO.endpoint
}