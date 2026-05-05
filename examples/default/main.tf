terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.71.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }

  backend "azurerm" {

  } # partial: terraform init -backend-config="backend-config.tfbackend"
}

provider "azurerm" {
  features {

  }
  skip_provider_registration = true
  storage_use_azuread        = true
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
  name                       = "TODO" # TODO update with module.naming.<RESOURCE_TYPE>.name_unique
  # resource_group_name        = azurerm_resource_group.rs_gr.name
  enable_telemetry           = var.enable_telemetry # see variables.tf
  devops_principle_client_id = ""
  naming_prefix              = ""
}