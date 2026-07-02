locals {
  devops_project_name = var.devops_project_name
  resource_group_name = var.resource_group_name
  prefix              = ""
  suffix              = "default"
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

  # backend "azurerm" {

  # } # partial: terraform init -backend-config="backend-config.tfbackend" comment this out when migrating state
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

data "azuredevops_project" "this" {
  name = local.devops_project_name
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
  devops_project_id        = data.azuredevops_project.this.id

  serviceconnections = {
    oidc_wip = {
      name                = "Managed Terraform Git Automation Service Connection/${local.suffix}"
      application_name    = "Managed Terraform Git Automation Application (${local.suffix})"
    }
  }
  service_connection_key = "oidc_wip"

  # variablegroups = {
  #   environment_dev_state = {
  #     name = "$(environment_name)-state-data"
  #   }
  #   environment_dev_config = {
  #     name = "(environment_name)-config-data"
  #   }
  # }
}