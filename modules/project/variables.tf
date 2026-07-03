
variable "location" {
  type        = string
  description = "(Required) The  resource location."
  nullable    = false
}

variable "name" {
  type        = string
  description = "(Required) The name of the project."
  nullable    = false
}

variable "description" {
  type        = string
  description = "The description of the project."
  nullable    = false
  default     = "Project"
}

variable "identity" {
  type        = string
  description = "(Required) Managed identity properties."
  nullable    = false
  default     = "SystemAssigned"
}

variable "parent_id" {
  type        = string
  description = "(Required) The full resource ID of the parent Resource Group."
  nullable    = false
}

variable "dev_center_id" {
  type        = string
  description = "(Required) Resource Id of an associated DevCenter."
  nullable    = false
}

variable "resource_type" {
  type        = string
  default     = "Microsoft.DevCenter/projects@2025-02-01"
  description = "(Optional) Override the AzAPI `<provider>/<resource>@<api-version>` string used to manage the resource. Defaults to the value tested with this module version."
  nullable    = false
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = <<-EOT
(Optional) Retry configuration applied to AzAPI resources managed by this module. Defaults to `null` (no custom retry).

- `error_message_regex` - (Optional) A list of regex patterns matching error messages that trigger a retry. Defaults to `null`.
- `interval_seconds` - (Optional) Initial interval between retries in seconds. Defaults to `null` (provider default).
- `max_interval_seconds` - (Optional) Maximum interval between retries in seconds. Defaults to `null` (provider default).
EOT
}

variable "role_assignment_definition_lookup_enabled" {
  type        = bool
  default     = true
  description = "(Optional) Whether the `role_assignments` submodule should resolve role definition names supplied via `role_definition_id_or_name` by querying the Azure Authorization API. Defaults to `true`. See the `role_assignments` submodule for details."
  nullable    = false
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = "(Optional) A map of role assignments to create at the container scope. Defaults to `{}`. See the `role_assignments` submodule for the attribute schema."
  nullable    = false
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<-EOT
(Optional) Per-operation timeouts applied to AzAPI resources managed by this module. Defaults to `null` (provider defaults). Each value is a Go duration string (e.g. `30m`, `1h`).

- `create` - (Optional) Timeout for create operations. Defaults to `null`.
- `read` - (Optional) Timeout for read operations. Defaults to `null`.
- `update` - (Optional) Timeout for update operations. Defaults to `null`.
- `delete` - (Optional) Timeout for delete operations. Defaults to `null`.
EOT
}
