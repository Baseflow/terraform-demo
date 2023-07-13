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
    key                  = "demo/demo-environments/development.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

module "resource_group" {
  source                  = "../../modules/resource-group/"
  resource_group_name     = var.environment
  resource_group_location = "westeurope"
}

module "storage-account" {
  source                           = "../../modules/storage-account/"
  resource_group_name              = module.resource_group.resource_group_name
  resource_group_location          = module.resource_group.resource_group_location
  storage_account_name             = "${var.environment}${random_id.demo.hex}"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  containers = [{
    name        = "cdn"
    access_type = "blob"

    },
    {
      name        = "${var.environment}-data"
      access_type = "private"
  }]
}


