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
}

provider "azurerm" {
  features {
    # We can tweak some more advanced settings here if we want to.
    # For example, we could configure resource groups to always be deleted,
    # even though they still have resources within them.
    # However, this features block is required although we can leave it empty
    # to work with sane defaults
  }
}

# Lets create a resource group first
resource "azurerm_resource_group" "demo" {
  name     = "demo-rg"
  location = "westeurope"
}

# Storage account in Azure require unique names, as their DNS will globally 
# be set to their name + ".blob.core.windows.net" (for example).
# Create a randon id generator which will help us with that.
resource "random_id" "demo" {
  byte_length = 4
}

# Notice I'm linking here to another resource. 
# This will also let Terraform know the azurerm_resource_group.demo resource
# must be created before we can start the storage account
# NOTE: Terraform can and will create resources in parallel, unless
# dependencies between them are clear.
resource "azurerm_storage_account" "demo" {
  name                     = "demos${random_id.demo.hex}"
  resource_group_name      = azurerm_resource_group.demo.name
  location                 = azurerm_resource_group.demo.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Linking to the azurerm_storage_account.demo resource will create a
# dependency to that, indicating to terraform to create that one first
# but if we want to be explicit, or have multiple or indirect dependencies, we
# can also add the 'depends_on' property
resource "azurerm_storage_container" "unicon_cdn_storage_container" {
  depends_on            = [azurerm_storage_account.demo]
  name                  = "cdn-container"
  storage_account_name  = azurerm_storage_account.demo.name
  container_access_type = "blob"
}
