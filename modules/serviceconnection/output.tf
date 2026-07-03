output "name" {
  description = "The name of the service endpoint."
  value       = azuredevops_serviceendpoint_azurerm.this.service_endpoint_name
}

output "application_id" {
  description = "The client ID of the application."
  value       = azuread_application.this.client_id
}

output "service_principal_client_id" {
  description = "The client ID of the service principal."
  value       = azuread_service_principal.this.client_id
}

output "service_principal_object_id" {
  description = "The object ID of the service principal."
  value       = azuread_service_principal.this.object_id
}

output "project_id" {
  description = "The ID of the DevOps project."
  value       = var.devops_project_id
}
