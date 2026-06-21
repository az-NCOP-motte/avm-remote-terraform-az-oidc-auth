#This file is to implement remote backend resource blocks for tf state

module "avm-storage-account" {
  source                          = "Azure/avm-res-storage-storageaccount/azurerm"
  location                        = module.az-environment-resourcegroup.location
  name                            = "${lower(var.environment_name)}mottepipeline"
  parent_id                       = module.az-environment-resourcegroup.resource_id
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
  public_network_access_enabled   = true
  network_rules = null

  containers = {
    tf_state = {
      name                       = "tfstate"
      container_access_type      = "private"
      rbac_authorization_enabled = true
      role_assignments = {
        rbac_storage_blob_data_contributor = {
          role_definition_id_or_name = "Storage Blob Data Contributor"
          principal_id               = data.azapi_client_config.current.object_id
        }
      }
    }
  }
}