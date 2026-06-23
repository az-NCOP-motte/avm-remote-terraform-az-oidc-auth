locals {
  subscription_id     = var.subscription_id
  resource_group_name = var.resource_group_name
  prefix              = ""
  suffix              = "git"
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
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }

  # backend "azurerm" {

  # } # partial: terraform init -backend-config="backend-config.tfbackend" comment this out when migrating state

  # backend "azurerm" {
  #   storage_account_name = module.this.module.avm-storage-account.name
  #   resource_group_name  = var.resource_group_name
  #   container_name       = module.this.module.avm-storage-account.containers.tf_state.name
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}
}

# import resource group that was created in set-up
import {
  to = module.this.module.az-environment-resourcegroup.azapi_resource.this
  id = "/subscriptions/${local.subscription_id}/resourceGroups/${local.resource_group_name}"
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
  resource_group_name        = var.resource_group_name
  devops_organization_name   = var.devops_organization_name
  enable_telemetry           = var.enable_telemetry
  devops_principle_client_id = var.devops_principle_client_id
  naming_prefix              = "motte"
  environment_name           = "def"
  storageaccounts = {
    tf_state_account = {
      name = module.naming.storage_account.name_unique
      containers = {
        tf_state_container = {
          name = "tfstate"
        }
      }
    }
  }
}
