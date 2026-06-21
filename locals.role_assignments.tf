# Locals for role assignments
locals {
  role_assignments = {
    global_owner = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Owner"
    }

    global_contributor = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Contributor"
    }

    storage_blob_data_contributor = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Storage Blob Data Contributor"
    }

    app_config_data_owner = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "App Configuration Data Owner"
    }

    vault_admin = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Key Vault Administrator"
    }

    secrets_user = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Key Vault Secrets User"
    }
    
    crypto_user = {
      principal_id               = local.service_principal_id
      role_definition_id_or_name = "Key Vault Crypto User"
    }
  }
}