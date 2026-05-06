#TODO implement remote backend resource blocks

# App Config for remote state and tfvars
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "TODO" {
  name                       = "exampleKVt123"
  location                   = azurerm_resource_group.TODO.location
  resource_group_name        = azurerm_resource_group.TODO.name
  enabled_for_disk_encryption = true
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = true

  depends_on = [
    azurerm_role_assignment.key_vault_contributer_devops_sp,
    azurerm_role_assignment.key_vault_devops_sp,
  ]
}

resource "azurerm_key_vault_key" "devops_principle_client" {
  name         = "service-principle-client-id"
  key_vault_id = azurerm_key_vault.TODO.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  depends_on = [
    azurerm_role_assignment.key_vault_contributer_devops_sp,
    azurerm_role_assignment.key_vault_devops_sp,
  ]
}

resource "azurerm_key_vault_secret" "devops_principle_client" {
  name         = "principle-client-id"
  value        = "client-id-here"
  key_vault_id = azurerm_key_vault.TODO.id

  depends_on = [
    azurerm_role_assignment.key_vault_contributer_devops_sp,
    azurerm_role_assignment.key_vault_devops_sp,
  ]
}

resource "azurerm_app_configuration" "TODO" {
  name                       = "az-terraform-devops-gitops-automation"
  resource_group_name        = azurerm_resource_group.TODO.name
  location                   = azurerm_resource_group.TODO.location
#   sku                        = "developer" # defaults to free
  local_auth_enabled         = true
  public_network_access      = "Disabled"
  purge_protection_enabled   = false
  soft_delete_retention_days = 1

  tags = {
    environment = "development"
  }

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

resource "azurerm_app_configuration_key" "az_app_config_resource_group_name" {
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "resource_group_name"
  value                  = azurerm_resource_group.TODO.name

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

resource "azurerm_app_configuration_key" "az_app_config_devops_principle_client" {
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "devops_principle_client_id_vault_ref"
  type                   = "vault"
  vault_key_reference    = azurerm_key_vault_secret.devops_principle_client.versionless_id

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp,
    azurerm_role_assignment.key_vault_contributer_devops_sp,
    azurerm_role_assignment.key_vault_devops_sp,
  ]
}

# Storage Account 
resource "azurerm_storage_account" "tf_state" {
  name                            = "${lower(var.environment_name)}strgmotte"
  resource_group_name             = data.azurerm_resource_group.dt_motte_cloud.name
  location                        = data.azurerm_resource_group.dt_motte_cloud.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
}

# Storage Container
resource "azurerm_storage_container" "tf_state" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.storage.id # nieuwe versie
  container_access_type = "private"
}

# Storage Blob
resource "azurerm_storage_blob" "tf_state" {
  name                   = "terraform.tfstate"
  storage_account_name   = azurerm_storage_account.tf_state.name
  storage_container_name = azurerm_storage_container.tf_state.name
  type                   = "Block"
  source                 = "terraform.tfstate"
  content_type           = "application/json"
  access_tier            = "Hot"
}

