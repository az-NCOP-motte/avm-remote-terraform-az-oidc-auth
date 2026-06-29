locals {
  subscription_id     = var.subscription_id
  devops_project_name = var.devops_project_name
  resource_group_name = var.resource_group_name
  prefix              = ""
  suffix              = "gitautomation"
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
      version = ">=1.15.1"
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
provider "azapi" {
  skip_provider_registration = true
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.devops_organization_name}"
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
  storage_use_azuread             = true
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
  environment_name           = "def"

  serviceconnections = {
    oidc_wip = {
      name                = "Managed Terraform Git Automation Service Connection"
      devops_project_name = local.devops_project_name
      application_name    = "Managed Terraform Git Automation Application"
    }
  }
  service_connection_key = "oidc_wip"
}
