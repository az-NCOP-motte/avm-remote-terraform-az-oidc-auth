output "azapi_client_config_object_id" {
  description = "The azapi_client_config tenant ID"
  value       = data.azapi_client_config.current.tenant_id
}

output "azuread_service_principal_client_id" {
  description = "The service principal client ID"
  value       = local.service_principal_client_id
}

output "BACKEND_AZURE_STORAGE_CONTAINER_NAMES" {
  description = "A map of all created storage container names"
  value = merge([
    for sa_key, sa in module.storageaccounts : {
      for container_key, container in sa.containers :
      "${container_key}" => container.name
    }
  ]...)
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAMES" {
  description = "A map of all created storage account names"
  value = {
    for key, sa in module.storageaccounts :
    key => sa.name
  }
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  description = "The resource group."
  value       = module.az-environment-resourcegroup.name
}

output "APP_CONFIG_ENDPOINTS" {
  description = "A map of all created app config endpoints"
  value = {
    for key, sa in module.appconfigurations :
    key => sa.endpoint
  }
}

output "DEBUG" {
  value = module.serviceconnections[var.service_connection_key]
}
