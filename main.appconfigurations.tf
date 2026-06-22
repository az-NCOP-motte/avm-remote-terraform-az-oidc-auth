module "appconfigurations" {
  source   = "Azure/avm-res-appconfiguration-configurationstore/azure"
  version  = "0.5.1"
  for_each = local.appconfigurations

  name                          = each.value.name
  public_network_access_enabled = true
  sku                           = each.value.sku
  purge_protection_enabled      = each.value.purge_protection_enabled
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  resource_group_resource_id    = module.az-environment-resourcegroup.resource_id
  location                      = each.value.location != null ? each.value.location : var.location

  key_values = {
    # my_secret_reference = {
    #   key          = "MySecretPrinciple"
    #   content_type = "application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8"
    #   value = jsonencode({
    #     uri = join("/", slice(split("/", module.key_vault.secrets.principle.id), 0, 5))
    #   })

    # }
    resource_group_name = {
      key   = "resource_group_name"
      value = module.az-environment-resourcegroup.name
    }
    enable_telemetry = {
      key   = "enable_telemetry"
      value = var.enable_telemetry
    }
    subscription_id = {
      key   = "subscription_id"
      value = var.subscription_id
    }
    location = {
      key   = "location"
      value = var.location
    }
    devops_organization_name = {
      key   = "devops_organization_name"
      value = var.devops_organization_name
    }
    environment_name = {
      key   = "environment_name"
      value = var.environment_name
    }
    devops_principle_client_id = {
      key   = "devops_principle_client_id"
      value = var.devops_principle_client_id
    }
  }

  role_assignments = {
    rbac_app_configuration_data_owner = local.role_assignments.app_config_data_owner
  }
}
