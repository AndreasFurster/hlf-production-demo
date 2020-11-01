terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create the resource group manually to prevent recreation everytime the infra is destroyed.

# resource "azurerm_resource_group" "azure_rg" {
#   name     =  var.rgname
#   location =  var.location
# }