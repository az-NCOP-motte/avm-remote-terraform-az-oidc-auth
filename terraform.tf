terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.8"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.71.0, <5.0.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=1.15.1"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }
}
