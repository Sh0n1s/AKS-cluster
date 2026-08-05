terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state-pl"
    storage_account_name = "stterraformstate9177"
    container_name       = "tfstate"
    key                  = "aks.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}
