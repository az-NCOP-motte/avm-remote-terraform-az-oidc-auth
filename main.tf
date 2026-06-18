provider "azapi" {
  skip_provider_registration = true
  # oidc_azure_service_connection_id = ""
}

module "az-environment-resourcegroup" {
  source  = "Azure/avm-res-resources-resourcegroup/azurerm"
  version = "0.4.0"

  location = var.location
  name     = var.resource_group_name # calling code must supply the name
}

moved {
  from = azurerm_resource_group.TODO
  to   = module.az-environment-resourcegroup.azapi_resource.this
}

data "azapi_client_config" "current" {}

moved {
  from = azurerm_client_config.current
  to   = azapi_client_config.current
}