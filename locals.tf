# General locals
locals {
  tenant_id       = data.azapi_client_config.current.tenant_id
  subscription_id = data.azapi_client_config.current.subscription_id
}
