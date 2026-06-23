#This file is to implement remote backend resource blocks for tf state

module "storageaccounts" {
  source   = "Azure/avm-res-storage-storageaccount/azurerm"
  for_each = local.storageaccounts

  location                        = module.az-environment-resourcegroup.location
  name                            = each.value.name
  parent_id                       = module.az-environment-resourcegroup.resource_id
  account_tier                    = each.value.account_tier
  account_replication_type        = each.value.account_replication_type
  shared_access_key_enabled       = each.value.shared_access_key_enabled
  default_to_oauth_authentication = each.value.default_to_oauth_authentication
  public_network_access_enabled   = each.value.public_network_access_enabled
  network_rules                   = each.value.network_rules
  containers                      = each.value.containers
  role_assignments = {
    rbac_storage_blob_data_contributor = local.role_assignments.storage_blob_data_contributor
  }
}