# This file is to implement resources for managed devops pool

#Dev Ops Pool
module "pools" {
  source  = "Azure/avm-res-devopsinfrastructure-pool/azurerm"
  for_each = local.pools
  version = "0.3.1"

  dev_center_project_resource_id = module.projects[each.value.project_key].resource_id
  location                       = module.az-environment-resourcegroup.location
  name                           = each.value.name
  resource_group_name            = module.az-environment-resourcegroup.name
  enable_telemetry               = each.value.enable_telemetry
  maximum_concurrency            = each.value.maximum_concurrency
  organization_profile = {
    organizations = [{ name = var.devops_organization_name }]
  }
  agent_profile_kind = "Stateless"
  role_assignments = {
    rbac_contributor = local.role_assignments.global_contributor
  }
  fabric_profile_os_disk_storage_account_type         = each.value.storage_account_type #'Standard', 'Premium' and 'StandardSSD',
  fabric_profile_sku_name                             = each.value.sku_name
  agent_profile_resource_prediction_profile_automatic = { "kind" : "Automatic", "prediction_preference" : each.value.prediction_profile_automatice }
  fabric_profile_images                               = each.value.profile_images
}
