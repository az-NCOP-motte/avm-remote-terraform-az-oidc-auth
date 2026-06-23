output "azapi_client_config_subscription_id" {
  value = module.this.azapi_client_config_subscription_id
}

output "azapi_client_config_object_id" {
  value = module.this.azapi_client_config_object_id
}

output "azuread_service_principal_client_id" {
  value = module.this.azuread_service_principal_client_id
}

output "BACKEND_AZURE_STORAGE_CONTAINER_NAMES" {
  value = module.this.BACKEND_AZURE_STORAGE_CONTAINER_NAMES
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAMES" {
  value = module.this.BACKEND_AZURE_STORAGE_ACCOUNT_NAMES
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  value = module.this.BACKEND_RESOURCE_GROUP_NAME
}

output "APP_CONFIG_ENDPOINTS" {
  value = module.this.APP_CONFIG_ENDPOINTS
}
