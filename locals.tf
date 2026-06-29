# TODO: insert locals here.
locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  tenant_id                          = data.azapi_client_config.current.tenant_id
  subscription_id                    = data.azapi_client_config.current.subscription_id
}
