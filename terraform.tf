terraform {
  required_version = ">=1.3.7"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.43.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
  }

  backend "azurerm" {

  } # partial: terraform init -backend-config="backend-config.tfbackend"
    # first deploy resources for remote backend through local CLI, then migrate state there
}