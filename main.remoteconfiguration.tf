# #This file is to implement remote App Config blocks for tfvars

# key vault & key
module "key_vault" {
  source  = "Azure/avm-res-keyvault-vault/azurerm"
  version = "0.10.0"

  location                      = module.az-environment-resourcegroup.location
  name                          = "${lower(var.environment_name)}-pipeline"
  resource_group_name           = module.az-environment-resourcegroup.name
  tenant_id                     = data.azapi_client_config.current.tenant_id
  public_network_access_enabled = true
  network_acls                  = null
  purge_protection_enabled      = var.purge_protection_enabled

  keys = {
    principle = {
      name     = "service-principle-client-id"
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
    principle = {
      name = "service-principle-client-id"
    }
  }

  secrets_value = {
    principle = data.azapi_client_config.current.object_id
  }

  role_assignments = {
    admin = {
      principal_id               = data.azapi_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Administrator"
    }
    user = {
      principal_id               = data.azapi_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Secrets User"
    }
    umi = {
      principal_id               = data.azapi_client_config.current.object_id
      role_definition_id_or_name = "Key Vault Crypto User"
    }
  }
}

# app config and key values
module "avm-res-appconfiguration-configurationstore" {
  source  = "Azure/avm-res-appconfiguration-configurationstore/azure"
  version = "0.5.1"

  location                      = module.az-environment-resourcegroup.location
  name                          = "${lower(var.environment_name)}-pipeline"
  resource_group_resource_id    = module.az-environment-resourcegroup.resource_id
  public_network_access_enabled = true
  sku                           = "standard"
  purge_protection_enabled      = var.purge_protection_enabled
  soft_delete_retention_days    = 3

  key_values = {
    my_secret_reference = {
      key          = "MySecretPrinciple"
      content_type = "application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8"
      value = jsonencode({
        uri = join("/", slice(split("/", module.key_vault.secrets.principle.id), 0, 5))
      })

    }
    resource_group_name = {
      key   = "resource_group_name"
      value = module.az-environment-resourcegroup.name
    }
    enable_telemetry = {
      key   = "enable_telemetry"
      value = var.enable_telemetry
    }
    subscription_id = {
      key   = "subscription_id"
      value = var.subscription_id
    }
    location = {
      key   = "location"
      value = var.location
    }
    devops_organization_url = {
      key   = "devops_organization_url"
      value = var.devops_organization_url
    }
    environment_name = {
      key   = "environment_name"
      value = var.environment_name
    }
    devops_principle_client_id = {
      key   = "devops_principle_client_id"
      value = var.devops_principle_client_id
    }
  }
}