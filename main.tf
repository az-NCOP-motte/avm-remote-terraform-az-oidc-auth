provider "azapi" {
  skip_provider_registration = true
  # oidc_azure_service_connection_id = ""
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  prefix  = [lower(var.naming_prefix)]
  suffix  = [lower(var.environment_name)]
}

# module "az-environment-resourcegroup" {
#   source = "./modules/resourcegroup"

#   # resource_type = var.resource_types.resourcegroup
#   parent_id     = module.az-environment-resourcegroup.resource_id
#   # parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
#   name             = var.resource_group_name
#   location         = var.location
#   environment_name = var.environment_name

#   role_assignments = {
#     global_owner = local.role_assignments.global_owner
#   }

#   timeouts = {
#     create = "5m"
#     delete = "10m"
#     read   = "5m"
#     update = "5m"
#   }
# }

module "az-environment-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.4.0"

  location = var.location
  name     = var.resource_group_name # calling code must supply the name

  role_assignments = {
    global_owner = local.role_assignments.global_owner
  }

  timeouts = {
    create = "5m"
    delete = "10m"
    read   = "5m"
    update = "5m"
  }
}

data "azapi_client_config" "current" {}

moved {
  from = azurerm_client_config.current
  to   = azapi_client_config.current
}
