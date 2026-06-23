module "keyvaults" {
  source   = "Azure/avm-res-keyvault-vault/azurerm"
  version  = "0.10.2"
  for_each = local.keyvaults

  location                      = module.az-environment-resourcegroup.location
  name                          = each.value.name
  resource_group_name           = module.az-environment-resourcegroup.name
  tenant_id                     = data.azapi_client_config.current.tenant_id
  sku_name                      = each.value.sku
  public_network_access_enabled = each.value.public_network_access_enabled
  network_acls                  = each.value.network_acls
  purge_protection_enabled      = each.value.purge_protection_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  keys                          = each.value.keys
  secrets                       = each.value.secrets
  secrets_value                 = each.value.secrets_value
  role_assignments = {
    rbac_key_vault_admin        = local.role_assignments.vault_admin
    rbac_key_vault_secrets_user = local.role_assignments.secrets_user
    rbac_key_vault_crypto_user  = local.role_assignments.crypto_user
  }
}
