resource "azuread_application" "this" {
  display_name = var.application_name
}

resource "azuread_service_principal" "this" {
  client_id = azuread_application.this.client_id
}

resource "azuredevops_serviceendpoint_azurerm" "this" {
  project_id                             = var.devops_project_id
  service_endpoint_name                  = var.name
  service_endpoint_authentication_scheme = "WorkloadIdentityFederation"
  credentials {
    serviceprincipalid = azuread_application.this.client_id
  }
  azurerm_spn_tenantid      = var.tenant_id
  azurerm_subscription_id   = var.subscription_id
  azurerm_subscription_name = "Filler Subscription Name"
}
