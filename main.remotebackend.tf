#This file is to implement remote backend resource blocks for tfvars

resource "azurerm_storage_account" "tf_state" {
  name                            = "${lower(var.environment_name)}rgmotte"
  resource_group_name             = azurerm_resource_group.TODO.name
  location                        = azurerm_resource_group.TODO.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  shared_access_key_enabled       = false
  default_to_oauth_authentication = true
}

# Storage Container
resource "azurerm_storage_container" "tf_state" {
  name                  = "${lower(var.environment_name)}tfstate"
  storage_account_id    = azurerm_storage_account.tf_state.id
  container_access_type = "private"
}