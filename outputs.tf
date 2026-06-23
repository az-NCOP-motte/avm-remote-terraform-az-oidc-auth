output "azapi_client_config_subscription_id" {
  value = data.azapi_client_config.current.subscription_id
}

output "azapi_client_config_object_id" {
  value = data.azapi_client_config.current.tenant_id
}

output "azuread_service_principal_client_id" {
  value = data.azuread_service_principal.devops_sp.client_id
}

output "BACKEND_AZURE_STORAGE_CONTAINER_NAMES" {
  value = merge([
    for sa_key, sa in module.storageaccounts : {
      for container_key, container in sa.containers :
      "${container_key}" => container.name
    }
  ]...)
}

output "BACKEND_AZURE_STORAGE_ACCOUNT_NAMES" {
  value = {
    for key, sa in module.storageaccounts :
    key => sa.name
  }
}

output "BACKEND_RESOURCE_GROUP_NAME" {
  value = module.az-environment-resourcegroup.name
}

output "APP_CONFIG_ENDPOINTS" {
  value = {
    for key, sa in module.appconfigurations :
    key => sa.endpoint
  }
}
