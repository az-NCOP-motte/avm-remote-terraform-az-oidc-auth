locals {
  keyvault_secrets = merge([
    for kv_key, kv in var.keyvaults : {
      for secret_key, secret in kv.secrets :
      secret_key => {
        keyvault_key = kv_key
        name         = secret.name
      }
    }
  ]...)
}
