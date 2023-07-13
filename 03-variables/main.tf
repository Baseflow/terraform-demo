terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.55.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate883210"
    container_name       = "tfstate"
    key                  = "demo/demo-variables.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "demo" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "random_id" "demo" {
  byte_length = 4
}

resource "azurerm_storage_account" "demo" {
  name                     = "demos${random_id.demo.hex}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
}

resource "azurerm_storage_container" "unicon_cdn_storage_container" {
  depends_on            = [azurerm_storage_account.demo]
  for_each              = { for each in var.containers : each.name => each }
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = each.value.access_type
}
