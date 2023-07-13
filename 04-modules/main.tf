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
    key                  = "demo/demo-modules.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

# add a demo resource group
module "demo-resource_group" {
  source                  = "../modules/resource-group/"
  resource_group_name     = "demo"
  resource_group_location = "westeurope"
}

# with a demo storage account
module "storage-account-demo" {
  source                           = "../modules/storage-account/"
  resource_group_name              = module.demo-resource_group.resource_group_name
  resource_group_location          = module.demo-resource_group.resource_group_location
  storage_account_name             = "demo${random_id.demo.hex}"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "LRS"
  containers = [{
    name        = "cdn"
    access_type = "blob"

    },
    {
      name        = "productiondata"
      access_type = "private"
  }]
}


# add a non demo resource group
module "non-demo-resource_group" {
  source                  = "../modules/resource-group/"
  resource_group_name     = "non-demo"
  resource_group_location = "westeurope"
}

# with a non-demo storage account
module "storage-account-non-demo" {
  source                           = "../modules/storage-account/"
  resource_group_name              = module.non-demo-resource_group.resource_group_name
  resource_group_location          = module.non-demo-resource_group.resource_group_location
  storage_account_name             = "nondemo${random_id.demo.hex}"
  storage_account_tier             = "Standard"
  storage_account_replication_type = "GRS"
  containers = [{
    name        = "invoices"
    access_type = "container"
    },
    {
      name        = "presentations"
      access_type = "blob"
  }]
}
