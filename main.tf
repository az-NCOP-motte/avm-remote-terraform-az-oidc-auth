# TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource


provider "azurerm" {
  features {

  }
  skip_provider_registration = true
  storage_use_azuread        = true
}

resource "azurerm_resource_group" "TODO" {
  location = var.location
  name     = var.resource_group_name # calling code must supply the name
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = azurerm_resource_group.TODO.id # TODO: Replace with your azurerm resource name
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

# Dev Ops Pool
resource "azurerm_dev_center" "example" {
  name                = "az-terraform-devops-pipeline"
  resource_group_name = azurerm_resource_group.TODO.name
  location            = azurerm_resource_group.TODO.location
}

resource "azurerm_dev_center_project" "example" {
  dev_center_id       = azurerm_dev_center.example.id
  resource_group_name = azurerm_resource_group.TODO.name
  location            = azurerm_resource_group.TODO.location
  name                = "example"
}

resource "azurerm_managed_devops_pool" "example" {
  name                  = "example-manageddevopspools"
  resource_group_name = azurerm_resource_group.TODO.name
  location            = azurerm_resource_group.TODO.location
  dev_center_project_id = azurerm_dev_center_project.example.id
  maximum_concurrency   = 1

  azure_devops_organization {
    organization {
      parallelism = 1
      url         = var.devops_organization_url
    }
  }

  stateless_agent {}

  virtual_machine_scale_set_fabric {
    sku_name = "Standard_D2ads_v5"

    image {
      aliases = [
        "ubuntu-24.04-g2",
        "az-pipeline", # add alias so that you keep pipeline configuration persistent as you update images
      ]

      well_known_image_name = "ubuntu-24.04-g2/latest"
    }
  }
}
# resource "azurerm_role_assignment" "this" {
#   for_each = var.role_assignments

#   principal_id                           = each.value.principal_id
#   scope                                  = azurerm_resource_group.TODO.id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
#   condition                              = each.value.condition
#   condition_version                      = each.value.condition_version
#   delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
#   principal_type                         = each.value.principal_type
#   role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
#   role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
#   skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
# }
