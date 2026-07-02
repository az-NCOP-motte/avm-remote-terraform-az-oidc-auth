resource "azuredevops_variable_group" "this" {

  project_id = var.devops_project_id

  name         = var.name
  description  = "This contains the values for storing our state data for the remote backend."
  allow_access = true

  dynamic "variable" {
    for_each = var.variable_blocks

    content {
      name  = variable.value.name
      value = variable.value.value
    }
  }
}
