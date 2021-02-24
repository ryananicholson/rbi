terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {
}

resource "azurerm_resource_group" "sec488-rg" {
  name     = "SEC488-RG"
  location = "Central US"
}

resource "random_string" "sec488-id" {
  length  = 16
  special = false
  upper   = false
}
