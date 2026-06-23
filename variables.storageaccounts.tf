variable "storageaccounts" {
  type = map(object({
    name                            = string
    location                        = optional(string, null)
    resource_group_name             = optional(string, null)
    account_tier                    = optional(string, "Standard")
    account_replication_type        = optional(string, "LRS")
    shared_access_key_enabled       = optional(bool, false)
    default_to_oauth_authentication = optional(bool, true)
    public_network_access_enabled   = optional(bool, true)
    network_rules = optional(object({
      bypass                     = optional(set(string), ["AzureServices"])
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(set(string), [])
      virtual_network_subnet_ids = optional(set(string), [])
      private_link_access = optional(list(object({
        endpoint_resource_id = string
        endpoint_tenant_id   = optional(string)
      })))
      timeouts = optional(object({
        create = optional(string)
        delete = optional(string)
        read   = optional(string)
        update = optional(string)
      }))
    }), null)

    containers = optional(map(object({
      name                       = optional(string, "tfstate")
      container_access_type      = optional(string, "private")
      rbac_authorization_enabled = optional(bool, true)

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
    })), {})

  }))
  default     = {}
  description = <<-EOT
A map of  to create on the parent resource group. The map key is arbitrary; the value supports the following attributes. Defaults to `{}` (no dev centers).

- `name` - (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the storage account.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the storage account.
- `role_assignments` - (Optional) A map of role assignments to create on the container. Defaults to `{}`. See `var.role_assignments` for the attribute schema.
EOT
  nullable    = false
}
