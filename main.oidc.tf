# When RG already exists in Azure; Read resource group; without managing it; no need to import
# data "azurerm_resource_group" "TODO" {
#   name = var.resource_group_name
# }

# The service principal you want to grant RBAC permissions to  # usage: principal_id         = data.azurerm_client_config.current.object_id  cant use this because setup is through personal az login
data "azuread_service_principal" "devops_sp" {
  client_id = var.devops_principle_client_id
}

resource "azurerm_role_assignment" "owner_devops_sp" {
  scope                = azurerm_resource_group.TODO.id
  role_definition_name = "Owner"
  principal_id         = data.azuread_service_principal.devops_sp.object_id
}

resource "azurerm_role_assignment" "blob_devops_sp" {
  scope                = azurerm_resource_group.TODO.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azuread_service_principal.devops_sp.object_id
}

resource "azurerm_role_assignment" "app_config_devops_sp" {
  scope                = azurerm_resource_group.TODO.id
  role_definition_name = "App Configuration Data Owner"
  principal_id         = data.azuread_service_principal.devops_sp.object_id
}

resource "azurerm_role_assignment" "key_vault_devops_sp" {
  scope                = azurerm_resource_group.TODO.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azuread_service_principal.devops_sp.object_id
}

resource "azurerm_role_assignment" "key_vault_contributer_devops_sp" {
  scope                = azurerm_resource_group.TODO.id
  role_definition_name = "Key Vault Contributor"
  principal_id         = data.azuread_service_principal.devops_sp.object_id
}
