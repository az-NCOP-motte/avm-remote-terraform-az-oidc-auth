resource "azapi_resource" "this" {
  type      = var.resource_type
  parent_id = var.parent_id
  name      = var.name
  location  = var.location
}