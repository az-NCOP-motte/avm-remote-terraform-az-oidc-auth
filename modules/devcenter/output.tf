output "name" {
  description = "The name of the dev center."
  value       = azapi_resource.this.name
}

output "location" {
  description = "The location of the dev center."
  value       = azapi_resource.this.location
}

output "resource" {
  description = "The full dev center azapi_resource."
  value       = azapi_resource.this
}

output "resource_id" {
  description = "The resource ID of the dev center azapi_resource."
  value       = azapi_resource.this.id
}