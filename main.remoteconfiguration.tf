#This file is to implement remote App Config blocks for tfvars

resource "azurerm_key_vault" "TODO" {
  name                        = "${lower(var.environment_name)}-pipeline"
  location                    = azurerm_resource_group.TODO.location
  resource_group_name         = azurerm_resource_group.TODO.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  rbac_authorization_enabled  = true

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
  name         = azurerm_key_vault_key.devops_principle_client.name
  value        = var.devops_principle_client_id # todo: consider using data.azurerm_client_config.current.object_id (as login principle is set in pipeline)
  key_vault_id = azurerm_key_vault.TODO.id

  depends_on = [
    azurerm_role_assignment.key_vault_contributer_devops_sp,
    azurerm_role_assignment.key_vault_devops_sp,
  ]
}

resource "azurerm_app_configuration" "TODO" {
  name                                 = "${lower(var.environment_name)}-pipeline"
  resource_group_name                  = azurerm_resource_group.TODO.name
  location                             = azurerm_resource_group.TODO.location
  local_auth_enabled                   = true
  public_network_access                = "Enabled"
  data_plane_proxy_authentication_mode = "Pass-through"
  # purge_protection_enabled             = true # defaults to false
  # soft_delete_retention_days           = 1
  # sku                                  = "developer" # defaults to free

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

# resource "azurerm_app_configuration_key" "az_app_config_enable_telemetry" {
#   configuration_store_id = azurerm_app_configuration.TODO.id
#   key                    = "enable_telemetry"
#   value                  = azurerm_storage_account.tf_state.name

#   depends_on = [
#     azurerm_role_assignment.app_config_devops_sp
#   ]
# }

resource "azurerm_app_configuration_key" "az_app_config_subscription_id" { # todo: consider using data.azurerm_client_config.current.subscription_id
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "subscription_id"
  value                  = var.subscription_id

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

resource "azurerm_app_configuration_key" "az_app_config_location" {
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "location"
  value                  = azurerm_resource_group.TODO.location

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

resource "azurerm_app_configuration_key" "az_app_config_devops_organisation_url" {
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "devops_organization_url"
  value                  = var.devops_organization_url

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

resource "azurerm_app_configuration_key" "az_app_config_environment_name" {
  configuration_store_id = azurerm_app_configuration.TODO.id
  key                    = "environment_name"
  value                  = var.environment_name

  depends_on = [
    azurerm_role_assignment.app_config_devops_sp
  ]
}

# Optional devops_principle_client_id App Config without Key Vault Usage
# resource "azurerm_app_configuration_key" "az_app_config_devops_principle_client_id" {
#   configuration_store_id = azurerm_app_configuration.TODO.id
#   key                    = "devops_principle_client_id"
#   value                  = azurerm_resource_group.TODO.name

#   depends_on = [
#     azurerm_role_assignment.app_config_devops_sp
#   ]
# }

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