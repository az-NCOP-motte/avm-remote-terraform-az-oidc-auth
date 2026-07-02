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
    devops_project_id = {
      key   = "devops_project_id"
      value = var.devops_project_id
    }
    environment_name = {
      key   = "environment_name"
      value = var.environment_name
    }
  }
}
