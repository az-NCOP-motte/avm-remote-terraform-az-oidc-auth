locals {
  subscription_id     = var.subscription_id
  devops_project_name = var.devops_project_name
  resource_group_name = var.resource_group_name
  prefix              = ""
  suffix              = "pool"
}

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
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">= 1.15.1"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}

provider "azurerm" {
  features {}
}

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = "0.4.2"
  prefix  = [local.prefix]
  suffix  = [local.suffix]
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "this" {
  source = "../../"

  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...

  resource_group_name      = var.resource_group_name
  devops_organization_name = var.devops_organization_name
  enable_telemetry         = var.enable_telemetry
  environment_name         = local.suffix

  serviceconnections = {
    oidc_wip = {
      name                = "Managed Terraform Git Automation Service Connection/${local.suffix}"
      devops_project_name = local.devops_project_name
      application_name    = "Managed Terraform Git Automation Application (${local.suffix})"
    }
  }
  service_connection_key = "oidc_wip"

  devcenters = {
    center_1 = {
      name = module.naming.app_configuration.name_unique
      projects = {
        project_1 = {
          name = module.naming.app_configuration.name_unique
          pools = {
            pool1 = {
              name                 = module.naming.app_configuration.name_unique
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
              name                = module.naming.app_configuration.name_unique
              maximum_concurrency = 1
            }
          }
        }
      }
    }
  }
}
