variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
  default     = "West Europe"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group provided by tfvars file."
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID of the resource group provided by tfvars file."
}


variable "environment_name" {
  type        = string
  description = "Name of the environment provided by tfvars file."
  default = "todo"

  validation {
    condition     = length(var.environment_name) >= 3 && length(var.environment_name) <= 8
    error_message = "Environment name should be between 3-8 characters. Submitted value was ${length(var.environment_name)}."
  }
}

variable "naming_prefix" {
  description = "Naming prefix for resources. Should be 3-8 characters."
  type        = string
  default     = "motteweb"

  validation {
    condition     = length(var.naming_prefix) >= 3 && length(var.naming_prefix) <= 8
    error_message = "Naming prefix should be between 3-8 characters. Submitted value was ${length(var.naming_prefix)}."
  }
}

variable "devops_principle_client_id" {
  type = string
}

variable "devops_organization_name" {
  type = string
}

variable "purge_protection_enabled" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not purge_protection is enabled for the module.
DESCRIPTION
  nullable    = false
}

variable "soft_delete_retention_days" {
  type        = number
  default     = 7
  description = <<DESCRIPTION
The number of days that items are retained before being permanently deleted. Default is 7. Set to `null` for `free` sku.
DESCRIPTION
  nullable    = true
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
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
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.
- `delegated_managed_identity_resource_id` - The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
- `principal_type` - The type of the principal_id. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the resource."
}

variable "resource_types" {
  type = object({
    devcenter = optional(string, "Microsoft.DevCenter/devCenters@2025-02-01")
    project   = optional(string, "Microsoft.DevCenter/projects@2025-02-01")
    lock      = optional(string, "Microsoft.Authorization/locks@2020-05-01")
  })
  default     = {}
  description = <<DESCRIPTION
Override the AzAPI `<provider>/<resource>@<api-version>` strings used by this module. Each key defaults to a tested value; supply only the keys you want to override. Useful when targeting a sovereign cloud with older API versions, or when opting into a newer preview API.

- `devcenter`  - The devcenter, used by the project.
- `project`    - The project, used by the pool.
- `lock`       - Management lock applied to the storage account (and to private endpoints when configured).
DESCRIPTION
  nullable    = false
}
