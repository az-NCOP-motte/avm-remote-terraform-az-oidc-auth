# The object ID of the service principal to assign roles to.
locals {
  service_principal_id = data.azuread_service_principal.devops_sp.object_id
}