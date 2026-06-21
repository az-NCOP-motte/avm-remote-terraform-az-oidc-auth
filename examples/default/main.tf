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
  to = module.test.azurerm_resource_group.TODO
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
module "test" {
  source = "../../"

  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
  # ...
  name                       = "TODO"
  resource_group_name        = var.resource_group_name
  subscription_id            = var.subscription_id
  devops_organization_name   = var.devops_organization_name
  enable_telemetry           = var.enable_telemetry
  devops_principle_client_id = var.devops_principle_client_id
  naming_prefix              = "motte"
  environment_name           = "def"
}