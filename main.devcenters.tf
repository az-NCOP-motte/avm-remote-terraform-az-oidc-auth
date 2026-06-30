module "centers" {
  source   = "./modules/devcenter"
  for_each = local.devcenters

  resource_type = var.resource_types.devcenter
  parent_id     = module.az-environment-resourcegroup.resource_id
  name          = each.value.name
  location      = each.value.location != null ? each.value.location : var.location

}
