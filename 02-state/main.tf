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
  # By defining the backend for azurerm resources, the state files will be
  # stored in the private container The state for this particular terraform
  # file (group of resources), will be stored in the demo/demo-state.tfstate
  # file
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate883210" # remember the unique id we created with the .sh script
    container_name       = "tfstate"
    key                  = "demo/demo-state.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

resource "azurerm_resource_group" "demo" {
  name     = "demo-rg"
  location = "westeurope"
}

resource "random_id" "demo" {
  byte_length = 4
}

resource "azurerm_storage_account" "demo" {
  name                     = "demos${random_id.demo.hex}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "unicon_cdn_storage_container" {
  depends_on            = [azurerm_storage_account.demo]
  name                  = "cdn-container"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "blob"
}
