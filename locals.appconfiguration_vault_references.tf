locals {
  appconfig_vault_refs  = merge([
    for ac_key, ac in var.appconfigurations : (
      try(ac.vault_references, {}) != {} ?
      {
        for ref_key, ref in ac.vault_references :
        "${ac_key}_${ref_key}" => {
          appconfig_key = ac_key
          name          = ref.name
          secret_key    = ref.secret_key
        }
      }
      : {}
    )
  ]...)
}