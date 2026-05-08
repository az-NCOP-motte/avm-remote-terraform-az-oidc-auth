terraform {
  required_version = ">=1.3.7"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.71.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}