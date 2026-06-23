# # #This file is to implement remote App Config blocks for tfvars

# # key vault & key
# module "key_vault" {
#   source  = "Azure/avm-res-keyvault-vault/azurerm"
#   version = "0.10.0"

#   location                      = module.az-environment-resourcegroup.location
#   name                          = module.naming.key_vault.name_unique
#   resource_group_name           = module.az-environment-resourcegroup.name
#   tenant_id                     = data.azapi_client_config.current.tenant_id
#   sku_name                      = "standard"
#   public_network_access_enabled = true
#   network_acls                  = null
#   purge_protection_enabled      = var.purge_protection_enabled
#   soft_delete_retention_days    = var.soft_delete_retention_days

#   keys = {
#     principle = {
#       name     = "service-principle-client-id"
#       key_type = "RSA"
#       key_size = 2048
#       key_opts = [
#         "decrypt",
#         "encrypt",
#         "sign",
#         "unwrapKey",
#         "verify",
#         "wrapKey"
#       ]
#       enabled = true
#     }
#   }

#   secrets = {
#     principle = {
#       name = "service-principle-client-id"
#     }
#   }

#   secrets_value = {
#     principle = data.azapi_client_config.current.object_id
#   }

#   role_assignments = {
#     rbac_key_vault_admin = local.role_assignments.vault_admin
#     rbac_key_vault_secrets_user = local.role_assignments.secrets_user
#     rbac_key_vault_crypto_user = local.role_assignments.crypto_user
#   }
# }