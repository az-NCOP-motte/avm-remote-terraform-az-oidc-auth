#This file is to implement remote backend resource blocks for tf state

module "storageaccounts" {
  source   = "Azure/avm-res-storage-storageaccount/azurerm"
  version  = "0.7.2"
  for_each = local.storageaccounts

  location                        = module.az-environment-resourcegroup.location
  name                            = each.value.name
  parent_id                       = module.az-environment-resourcegroup.resource_id
  account_sku_name                = each.value.account_sku_name
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  default_to_oauth_authentication = each.value.default_to_oauth_authentication
  public_network_access_enabled   = each.value.public_network_access_enabled
  network_rules                   = each.value.network_rules
  containers                      = each.value.containers
  role_assignments = {
    rbac_storage_blob_data_contributor = local.role_assignments.storage_blob_data_contributor
  }
}

module "state_data_azuredevops_variable_groups" {
  source   = "./modules/variablegroup"
  for_each = local.storageaccounts

  name              = "${var.environment_name}-state-data"
  description       = "This contains the values for storing our state data for the remote backend."
  allow_access      = true
  devops_project_id = var.devops_project_id

  variable_blocks = [
    {
      name  = "BACKEND_AZURE_STORAGE_ACCOUNT_CONTAINER_NAME"
      value = "tfstate"
    },
    {
      name  = "BACKEND_AZURE_STORAGE_ACCOUNT_KEY_NAME"
      value = "terraform.tfstate"
    },
    {
      name  = "BACKEND_AZURE_STORAGE_ACCOUNT_NAME"
      value = each.value.name
    },
    {
      name  = "BACKEND_RESOURCE_GROUP_NAME"
      value = var.resource_group_name
    },
  ]
}
