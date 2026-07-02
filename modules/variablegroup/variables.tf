variable "name" {
  type        = string
  description = "The name of the Azure DevOps service connection."
}

variable "description" {
  type        = string
  description = "(Optional) The description of the Variable Group."
}

variable "allow_access" {
  type        = bool
  description = "(Required) Boolean that indicate if this variable group is shared by all pipelines of this project."
}

variable "variable_blocks" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "devops_project_id" {
  type        = string
  description = "The ID of the Azure DevOps project."
}
