variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group provided by tfvars file."
  default     = "avm-remote-terraform-az-oidc-auth"
}

variable "subscription_id" {
  type        = string
  description = "Subscription ID of the resource group provided by tfvars file."
  default     = "xxx"
}

variable "devops_principle_client_id" {
  type        = string
  description = "Subscription ID of the resource group provided by tfvars file."
  default     = "xxx"
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
  default     = "West Europe"
}