terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.71.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }

  backend "azurerm" {

  } # partial: terraform init -backend-config="backend-config.tfbackend" comment this out when migrating state

  # backend "azurerm" {
  #   storage_account_name = module.test.azurerm_storage_account.tf_state.name
  #   resource_group_name  = var.resource_group_name
  #   container_name       = module.test.azurerm_storage_container.tf_state.name
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {
    # resource_group {
    #   prevent_deletion_if_contains_resources = true
    # }
  }
  skip_provider_registration = true
  storage_use_azuread        = true
}

# import resource group that was created in set-up
import {
  to = module.test.module.az-environment-resourcegroup.azapi_resource.this
  id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "~> 0.3"
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "this" {
  source = "../../"

  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...

  devcenters = {
    center_1 = {
      name = "git-automation"
      projects = {
        project_1 = {
          name = "git-automation"
          pools = {
            pool1 = {
              name                 = "git-automation"
              storage_account_type = "Standard"
              maximum_concurrency  = 1
              profile_images = [
                {
                  "aliases" : [
                    "ubuntu-24.04-g2",
                    "git-automation",
                  ],
                  "well_known_image_name" : "ubuntu-24.04-g2/latest"
                }
              ]
            }
            pool2 = {
              name                = "git-automation-two"
              maximum_concurrency = 1
            }
          }
        }
      }
    }
  }

  # projects = {
  #   project_1 = {
  #     name       = "pool"
  #     center_key = "center_1"
  #     pools = {
  #       pool1 = {
  #         name                = "pool" # 3 - 44
  #         project_key         = "project_1"
  #         maximum_concurrency = 2
  #       }
  #     }
  #   }
  # }

  # pools = {
  #   pool1 = {
  #     name                = "pool" # 3 - 44
  #     project_key         = "project_1"
  #     maximum_concurrency = 2
  #   }
  # }

  name                       = "TODO"
  resource_group_name        = var.resource_group_name
  subscription_id            = var.subscription_id
  devops_organization_name   = var.devops_organization_name
  enable_telemetry           = var.enable_telemetry
  devops_principle_client_id = var.devops_principle_client_id
  naming_prefix              = "motte"
  environment_name           = "proto1"
  purge_protection_enabled   = false
  soft_delete_retention_days = null
}
