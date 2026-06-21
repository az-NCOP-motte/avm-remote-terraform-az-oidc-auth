module "projects" {
  source        = "./modules/project"
  for_each      = local.projects
  
  dev_center_id = module.centers[each.value.center_key].resource_id
  name          = each.value.name
  resource_type = var.resource_types.project
  location      = each.value.location != null ? each.value.location : var.location
  parent_id     = module.az-environment-resourcegroup.resource_id
}