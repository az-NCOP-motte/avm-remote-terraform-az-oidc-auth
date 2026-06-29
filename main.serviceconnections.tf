module "serviceconnections" {
  source   = "./modules/serviceconnection"
  for_each = local.serviceconnections

  name                = each.value.name
  application_name    = each.value.application_name
  devops_project_name = each.value.devops_project_name
  subscription_id     = local.subscription_id
  tenant_id           = local.tenant_id
}
