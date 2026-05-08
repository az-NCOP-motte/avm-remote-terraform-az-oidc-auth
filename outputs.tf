output "storage_account_name" {
  value = azurerm_storage_account.tf_state.id
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
