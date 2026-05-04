output "storage_account_name" {
  value = azurerm_storage_account.storage.id
}

output "azuread_service_principal_clientID" {
  value = var.devops-principle-client-id
}