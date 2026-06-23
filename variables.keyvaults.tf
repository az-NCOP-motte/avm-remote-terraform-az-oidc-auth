variable "keyvaults" {
  type = map(object({
    name                = string
    location            = optional(string, null)
    resource_group_name = optional(string, null)

    network_acls = optional(object({
      bypass                     = optional(string, "None")
      default_action             = optional(string, "Deny")
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
      })
    , null)
    public_network_access_enabled = optional(bool, true)
    sku                           = optional(string, "standard")
    purge_protection_enabled      = optional(bool, false)
    soft_delete_retention_days    = optional(number, null)

    keys = optional(map(object({
      name            = string
      key_type        = string
      key_opts        = optional(list(string), ["sign", "verify"])
      key_size        = optional(number, null)
      curve           = optional(string, null)
      not_before_date = optional(string, null)
      expiration_date = optional(string, null)
      tags            = optional(map(any), null)
      role_assignments = optional(map(object({
        role_definition_id_or_name             = string
        principal_id                           = string
        description                            = optional(string, null)
        skip_service_principal_aad_check       = optional(bool, false)
        condition                              = optional(string, null)
        condition_version                      = optional(string, null)
        delegated_managed_identity_resource_id = optional(string, null)
        principal_type                         = optional(string, null)
      })), {})
      rotation_policy = optional(object({
        automatic = optional(object({
          time_after_creation = optional(string, null)
          time_before_expiry  = optional(string, null)
        }), null)
        expire_after         = optional(string, null)
        notify_before_expiry = optional(string, null)
      }), null)
    })), {})

    secrets = optional(map(object({
      name            = string
      content_type    = optional(string, null)
      tags            = optional(map(any), null)
      not_before_date = optional(string, null)
      expiration_date = optional(string, null)

      role_assignments = optional(map(object({
        role_definition_id_or_name             = string
        principal_id                           = string
        description                            = optional(string, null)
        skip_service_principal_aad_check       = optional(bool, false)
        condition                              = optional(string, null)
        condition_version                      = optional(string, null)
        delegated_managed_identity_resource_id = optional(string, null)
        principal_type                         = optional(string, null)
      })), {})
    })), {})

    secrets_value = optional(map(string), null)

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
- `network_acls` - (Optional) The network ACL configuration for the Key Vault. If not specified then the Key Vault will be created with a firewall that blocks access. Specify `null` to create the Key Vault with no firewall. - `bypass` - (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`. - `default_action` - (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`. - `ip_rules` - (Optional) A list of IP rules in CIDR format. Defaults to `[]`. - `virtual_network_subnet_ids` - (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to `[]`.
- `public_network_access_enabled` - (Optional) Specifies whether public access is permitted.
- `sku` - (Optional) The SKU name of the Key Vault. Default is `standard`. Possible values are `standard` and `premium`.
- `purge_protection_enabled` - (Optional) Specifies whether protection against purge is enabled for this Key Vault. Note once enabled this cannot be disabled.
- `soft_delete_retention_days` - (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days.
- `keys` - (Optional) A map of keys to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.  - `name` - The name of the key. - `key_type` - The type of the key. Possible values are `EC` and `RSA`. - `key_opts` - A list of key options. Possible values are `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify`, and `wrapKey`. - `key_size` - The size of the key. Required for `RSA` keys. - `curve` - The curve of the key. Required for `EC` keys. Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. The API will default to `P-256` if nothing is specified. - `not_before_date` - The not before date of the key. - `expiration_date` - The expiration date of the key. - `tags` - A mapping of tags to assign to the key. - `rotation_policy` - The rotation policy of the key. - `automatic` - The automatic rotation policy of the key. - `time_after_creation` - The time after creation of the key before it is automatically rotated. - `time_before_expiry` - The time before expiry of the key before it is automatically rotated. - `expire_after` - The time after which the key expires. - `notify_before_expiry` - The time before expiry of the key when notification emails will be sent. Supply role assignments in the same way as for `var.role_assignments`.
- `secrets` - (Optional) A map of secrets to create on the Key Vault. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. - `name` - The name of the secret. - `content_type` - The content type of the secret. - `tags` - A mapping of tags to assign to the secret. - `not_before_date` - The not before date of the secret. - `expiration_date` - The expiration date of the secret. Supply role assignments in the same way as for `var.role_assignments`. > Note: the `value` of the secret is supplied via the `var.secrets_value` variable. Make sure to use the same map key.
- `secrets_value` - (Optional) A map of secret keys to values. The map key is the supplied input to `var.secrets`. The map value is the secret value. This is a separate variable to `var.secrets` because it is sensitive and therefore cannot be used in a `for_each` loop.
EOT
  nullable    = false
}
