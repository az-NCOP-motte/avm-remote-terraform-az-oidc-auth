output "name" {
  description = "The name of the variable group."
  value       = azuredevops_variable_group.this.name
}

output "variable_blocks" {
  description = "The variable group variable blocks."
  value       = var.variable_blocks
}
