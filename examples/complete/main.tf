locals {
  subscription_id     = var.subscription_id
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

provider "azurerm" {
  features {
    # resource_group {
    #   prevent_deletion_if_contains_resources = true
    # }
  }
  resource_provider_registrations = "none"
  storage_use_azuread             = true
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
  environment_name           = "def"

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

  appconfigurations = {
    tf_tfvars = {
      name                       = module.naming.app_configuration.name_unique
      purge_protection_enabled   = false
      soft_delete_retention_days = null
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
      name = module.naming.key_vault.name_unique
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
