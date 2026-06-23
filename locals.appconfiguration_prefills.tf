locals {
  appconfig_key_values_prefill = {
    resource_group_name = {
      key   = "resource_group_name"
      value = module.az-environment-resourcegroup.name
    }
    enable_telemetry = {
      key   = "enable_telemetry"
      value = var.enable_telemetry
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
}