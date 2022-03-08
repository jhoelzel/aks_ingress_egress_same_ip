terraform {
  # 1. Required Version Terraform
  required_version = ">= 0.13"
  # 2. Required Terraform Providers  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "aks_rg" {
  name = "terraform-storage-rg"
  location = var.location
}

resource "azurerm_storage_account" "terraformstatestoredev" {
  name                     = "terraformstatestoredev"
  resource_group_name      = "terraform-storage-rg"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "dev"
  }
  depends_on = [
    azurerm_resource_group.aks_rg,
  ]
}
resource "azurerm_storage_container" "tfstatefiles" {
  name                  = "tfstatefiles"
  storage_account_name  = "terraformstatestoredev"
  container_access_type = "private"
  depends_on = [
    azurerm_storage_account.terraformstatestoredev,
  ]
}