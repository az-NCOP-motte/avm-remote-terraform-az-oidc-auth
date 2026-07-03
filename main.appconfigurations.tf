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

  key_values = merge({
    for k, v in local.appconfig_key_values :
    k => v
    if startswith(k, "${each.key}_")
    },
    local.appconfig_key_values_prefill
  )

  role_assignments = {
    rbac_app_configuration_data_owner = local.role_assignments.app_config_data_owner
  }
}

module "config_data_azuredevops_variable_groups" {
  source   = "./modules/variablegroup"
  for_each = local.appconfigurations

  name              = "${var.environment_name}-config-data"
  description       = "This contains the values for where we want to retrieve our configuration data from, which is the Azure AppConfig endpoint."
  allow_access      = true
  devops_project_id = var.devops_project_id

  variable_blocks = [
    {
      name  = "app-config-endpoint"
      value = module.appconfigurations[each.key].endpoint
    }
  ]
}
