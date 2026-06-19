#This file is to implement remote App Config blocks for tfvars

# key vault & key
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.0"

  location                      = module.az-environment-resourcegroup.location
  name                          = module.naming.key_vault.name_unique
  resource_group_name           = amodule.az-environment-resourcegroup.name
  tenant_id                     = data.azapi_client_config.current.tenant_id
  public_network_access_enabled = true
  network_acls                  = null

  keys = {
    service-principle-client-id = {
      name     = "service-principle-client-id"
      key_type = "RSA"
      key_size = 2048
      key_opts = [
        "decrypt",
        "encrypt",
        "sign",
        "unwrapKey",
        "verify",
        "wrapKey"
      ]
      enabled = true
    }
  }
  role_assignments = {
    admin = {
      principal_id               = data.azapi_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Administrator"
    }
    user = {
      principal_id               = data.azapi_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Secrets User"
    }
    umi = {
      principal_id               = azapi_resource.umi.output.properties.principalId
      role_definition_id_or_name = "Key Vault Crypto User"
      principal_type             = "ServicePrincipal"
    }
  }
}