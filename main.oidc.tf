# Retrieve the service principal you want to grant RBAC permissions to  # note: can't use data.azurerm_client_config.current.object_id because setup is through personal az login
data "azuread_service_principal" "devops_sp" {
  client_id = var.devops_principle_client_id
}
