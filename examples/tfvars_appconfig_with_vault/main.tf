locals {
  devops_project_name = var.devops_project_name
  resource_group_name = var.resource_group_name
  prefix              = ""
  suffix              = "config_vault"
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

provider "azurerm" {
  features {}
}

provider "azapi" {
  skip_provider_registration = true
}

provider "azuredevops" {
  org_service_url = "https://dev.azure.com/${var.devops_organization_name}"
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

  appconfigurations = {
    tf_tfvars = {
      name                          = module.naming.app_configuration.name_unique
      purge_protection_enabled      = false
      soft_delete_retention_days    = null
      public_network_access_enabled = true
      # vault references here
      vault_references = {
        key_ref_1 = {
          name = "vault_ref1"
          # the referance from config below
          secret_key = "secret_1"
        }
      }
    }
  }

  # the key vault config
  keyvaults = {
    key_vault_1 = {
      name                          = module.naming.key_vault.name_unique
      public_network_access_enabled = true
      keys = {
        secret_1 = {
          name     = module.naming.key_vault_key.name_unique
          key_type = "RSA"
          key_size = 2048
          key_opts = [
            "decrypt",
            "encrypt",
            "sign",
            "unwrapKey",
            "verify",
            "wrapKey"
          ]
          enabled = true
        }
      }

      secrets = {
        secret_1 = {
          name = module.naming.key_vault_secret.name_unique
        }
      }

      secrets_value = {
        secret_1 = "supersecretpassword123"
      }
    }
  }
}

moved {
  from = module.test
  to   = module.this
}
