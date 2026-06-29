variable "storageaccounts" {
  type = map(object({
    name                            = string
    location                        = optional(string, null)
    resource_group_name             = optional(string, null)
    account_sku_name                = optional(string, "Standard_LRS")
    shared_access_key_enabled       = optional(bool, false)
    default_to_oauth_authentication = optional(bool, true)
    public_network_access_enabled   = optional(bool, false)
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
- `account_sku_name` (Optional) Explicit storage account SKU name (e.g. `Standard_LRS`, `Premium_ZRS`, `PremiumV2_LRS`, `StandardV2_GZRS`). When set, this value is sent to Azure verbatim and overrides the SKU derived from `account_tier`, `account_replication_type` and `provisioned_billing_model_version` - those variables are only honoured when `account_sku_name` is explicitly set to `null`. Defaults to `Standard_ZRS`. Note: the `*V2_*` SKUs (e.g. `StandardV2_ZRS`, `PremiumV2_ZRS`) require `account_kind = "FileStorage"`. Default: "Standard_ZRS"
- `public_network_access_enabled` (Optional) Whether the public network access is enabled? Defaults to `false`.
- `network_rules` (Optional) Network rules restricting access to the storage account. Defaults to `{}`, which applies the object's own per-attribute defaults (effectively `default_action = "Deny"` with `bypass = ["AzureServices"]`). > Note: the default value blocks all public access to the storage account. If you want to disable all network rules, set this value to `null`. - `bypass` - (Optional) Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of `Logging`, `Metrics`, `AzureServices`, or `None`. Defaults to `["AzureServices"]`. - `default_action` - (Optional) Specifies the default action of allow or deny when no other rules match. Valid options are `Deny` or `Allow`. Defaults to `Deny`. - `ip_rules` - (Optional) List of public IP or IP ranges in CIDR format. Only IPv4 addresses are allowed. Private IP address ranges (as defined in [RFC 1918](https://tools.ietf.org/html/rfc1918#section-3)) are not allowed. Defaults to `[]`. - `virtual_network_subnet_ids` - (Optional) A set of virtual network subnet IDs to secure the storage account. Defaults to `[]`. - `private_link_access` - (Optional) A list of private link access rules. Defaults to `null`. Each entry supports: - `endpoint_resource_id` - (Required) The resource ID of the resource access rule to be granted access. - `endpoint_tenant_id` - (Optional) The tenant ID of the resource of the resource access rule to be granted access. Defaults to the current tenant ID. - `timeouts` - (Optional) Per-operation timeouts for the network rules resource. Defaults to `null` (uses provider defaults). Supports: - `create` - (Optional) Timeout for create operations. - `delete` - (Optional) Timeout for delete operations. - `read` - (Optional) Timeout for read operations. - `update` - (Optional) Timeout for update operations. Default {}
- `role_assignments` - (Optional) A map of role assignments to create on the container. Defaults to `{}`. See `var.role_assignments` for the attribute schema.


Example Input:
```hcl
storageaccounts = {
  tf_state_account = {
    name = module.naming.storage_account.name_unique
    containers = {
      tf_state_container = {
        name = "tfstate"
      }
    }
  }
}
```
EOT
  nullable    = false
}
