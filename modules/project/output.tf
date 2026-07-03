output "name" {
  description = "The name of the project."
  value       = azapi_resource.this.name
}

output "location" {
  description = "The location of the project."
  value       = azapi_resource.this.location
}

output "resource" {
  description = "The full project azapi_resource."
  value       = azapi_resource.this
}

output "resource_id" {
  description = "The resource ID of the project azapi_resource."
  value       = azapi_resource.this.id
}

output "dev_center_id" {
  description = "The resource ID of the parent dev center."
  value       = var.dev_center_id
}
