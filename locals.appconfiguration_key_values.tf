locals {
  appconfig_key_values = {
    for ref_key, ref in local.appconfig_vault_refs :
    "${ref.appconfig_key}_${ref.name}" => {
      key          = ref.name
      content_type = "application/vnd.microsoft.appconfig.keyvaultref+json;charset=utf-8"
      value = jsonencode({
        uri = local.keyvault_secret_uris[ref.secret_key]
      })
      label = null
      tags  = null
    }
  }
}
