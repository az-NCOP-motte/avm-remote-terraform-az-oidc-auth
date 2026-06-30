# The object ID of the service principal to assign roles to. 
locals {
  service_principal_object_id = module.serviceconnections[var.service_connection_key].service_principal_object_id
  service_principal_client_id = module.serviceconnections[var.service_connection_key].service_principal_client_id
}
