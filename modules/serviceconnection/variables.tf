variable "name" {
  type        = string
  description = "The name of the Azure DevOps service connection."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID used by the service connection."
}

variable "application_name" {
  type        = string
  description = "(Optional) The display name for the application."
  default     = "Application for serivce connection."
}

variable "tenant_id" {
  type        = string
  description = "The Azure AD tenant ID associated with the service principal."
}

variable "devops_project_id" {
  type        = string
  description = "(Required) The ID of the DevOps project."
  nullable    = false
}
