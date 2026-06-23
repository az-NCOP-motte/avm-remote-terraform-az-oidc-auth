variable "appconfigurations" {
  type = map(object({
    name                = string
    location            = optional(string, null)
    resource_group_name = optional(string, null)

    public_network_access_enabled = optional(bool, true)
    sku                           = optional(string, "developer")
    purge_protection_enabled      = optional(bool, false)
    soft_delete_retention_days    = optional(number, null)
    vault_references = optional(map(object({
      name       = string
      secret_key = string
    })), {})
    key_values = optional(map(object({
      key          = string
      value        = string
      content_type = optional(string, null)
      label        = optional(string, null)
      tags         = optional(map(string), null)
    })), {})

    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      principal_type                         = optional(string, null)
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
  }))
  default     = {}
  description = <<-EOT
A map of dev centers to create on the parent resource group. The map key is arbitrary; the value supports the following attributes. Defaults to `{}` (no dev centers).

- `name` - (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the storage account.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the storage account.
- `role_assignments` - (Optional) A map of role assignments to create on the container. Defaults to `{}`. See `var.role_assignments` for the attribute schema.
EOT
  nullable    = false
}
