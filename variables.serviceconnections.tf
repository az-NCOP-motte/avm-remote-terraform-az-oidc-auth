variable "serviceconnections" {
  type = map(object({
    name                                   = string
    application_name                       = optional(string, null)
    service_endpoint_authentication_scheme = optional(string, "ServicePrincipal")
  }))
  default     = {}
  description = <<-EOT
A map of service connections to create on the parent subscription. The map key is arbitrary; the value supports the following attributes. Defaults to `{}` (no service connections).

- `name` - (Required) The Service Endpoint Name.
- `devops_project_name` - (Required) The Project Name.
- `app_registration_name` - (Optional) The display name for the application.
- `service_endpoint_authentication_scheme` (WIP) Specifies the type of Azure Resource Manager Service Endpoint. Possible values are WorkloadIdentityFederation, ManagedServiceIdentity or ServicePrincipal. Defaults to ServicePrincipal for backwards compatibility.

Example Input:
```hcl
serviceconnections = {
  oidc_wip = {
    name                = "Managed Terraform Git Automation Service Connection"
    devops_project_name = local.project_name
    application_name    = "Managed Terraform Git Automation Application"
  }
}
service_connection_key = "oidc_wip"
```
EOT
  nullable    = false
}
