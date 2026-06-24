locals {
  keyvault_secret_uris = {
    for secret_key, secret in local.keyvault_secrets :
    secret_key => module.keyvaults[secret.keyvault_key].secrets[secret_key].versionless_id
  }
}
