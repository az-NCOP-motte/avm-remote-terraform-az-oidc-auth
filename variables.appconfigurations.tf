variable "appconfigurations" {
  type = map(object({
    name                          = string
    location                      = optional(string, null)
    resource_group_name           = optional(string, null)
    public_network_access_enabled = optional(bool, false)
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
  description = <<DESCRIPTION
A map of app configurations to create for tfvars. The map key is arbitrary; the value supports the following attributes. Defaults to `{}` (no app configurations).

- `name` - (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the storage account.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the storage account.
- `public_network_access_enabled` (Optional) Whether to enable public network access, default is `false`.
- `sku`- (Optional) The SKU of the resource. Valid values are free, developer, standard, and premium. Set `soft_delete_retention_days` to `null` for free sku. Default is `developer`
- `purge_protection_enabled` - (Optional) Whether to enable purge protection, default is `false`.
- `soft_delete_retention_days` - (Optional) The number of days that items are retained before being permanently deleted. Default is `null`.
- `vault_references` - (Optional) Map of objects for vault references. `secret_key` refers to the key value from the `keys` object within `keyvaults` input variable. 
- `key_values` - (Optional) A map a key-value pairs to prefill the configuration with.

- `role_assignments` - (Optional) A map of role assignments to create on the container. Defaults to `{}`. See `var.role_assignments` for the attribute schema.

Example Input:
```hcl
appconfigurations = {
  tf_tfvars = {
    name                       = module.naming.app_configuration.name_unique
    purge_protection_enabled   = false
    soft_delete_retention_days = null
    vault_references = {
      key_ref_1 = {
        name = "vault_ref1"
        secret_key = "secret_1"
      }
    }
  }
}
```
DESCRIPTION
  nullable    = false
}
