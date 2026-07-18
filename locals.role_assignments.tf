locals {
  role_assignments_principal_id = local.service_principal_object_id
}

# Locals for role assignments
locals {
  role_assignments = {
    global_owner = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Owner"
      principal_type             = "ServicePrincipal"
    }

    global_contributor = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Contributor"
      principal_type             = "ServicePrincipal"
    }

    storage_blob_data_contributor = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Storage Blob Data Contributor"
      principal_type             = "ServicePrincipal"
    }

    app_config_data_owner = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "App Configuration Data Owner"
      principal_type             = "ServicePrincipal"
    }

    vault_admin = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Key Vault Administrator"
      principal_type             = "ServicePrincipal"
    }

    secrets_user = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Key Vault Secrets User"
      principal_type             = "ServicePrincipal"
    }

    crypto_user = {
      principal_id               = local.role_assignments_principal_id
      role_definition_id_or_name = "Key Vault Crypto User"
      principal_type             = "ServicePrincipal"
    }
  }
}
