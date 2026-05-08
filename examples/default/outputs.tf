output "azurerm_client_config_object_id" {
  value = module.test.azurerm_client_config_object_id
}

output "azurerm_client_config_subscription_id" {
  value = module.test.azurerm_client_config_subscription_id
}

output "azuread_service_principal_clientID" {
  value = module.test.azuread_service_principal_clientID
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME" {
  value = module.test.BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_KEY_NAME" {
  value = module.test.BACKEND_AZURE_STORAGE_ACCOUNT_KEY_NAME
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAME" {
  value = module.test.BACKEND_AZURE_STORAGE_ACCOUNT_NAME
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  value = module.test.BACKEND_RESOURCE_GROUP_NAME
}

output "APP_CONFIG_ENDPOINT" {
  value = module.test.APP_CONFIG_ENDPOINT
}