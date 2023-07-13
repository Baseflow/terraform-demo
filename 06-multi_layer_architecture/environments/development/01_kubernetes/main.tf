terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.55.0"
    }

  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate883210"
    container_name       = "tfstate"
    key                  = "demo/mla/development/kubernetes.tfstate"
  }
}

provider "azurerm" {
  features {
  }
}

module "resource_group" {
  source                  = "../../../../modules/resource-group/"
  resource_group_name     = "aks_${var.environment}"
  resource_group_location = "westeurope"
}

module "network" {
  source                  = "../../../../modules/network/"
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  vnet_address_space      = "10.220.0.0/15" # ranges 	10.220.0.1 - 10.221.255.254
  vnet_name               = "aks_vnet"
  subnets = [{
    name           = "aks-subnet"
    address_prefix = "10.220.0.0/16" # ranges 	10.220.0.1 - 10.220.255.254
    },
    {
      name           = "ingress-appgateway-subnet"
      address_prefix = "10.221.0.0/16" # ranges 	10.221.0.1 - 10.221.255.254
  }]
}

module "kubernetes" {
  source                                = "../../../../modules/kubernetes/"
  resource_group_name                   = module.resource_group.resource_group_name
  resource_group_location               = module.resource_group.resource_group_location
  aks_subnet_id                         = module.network.subnets["aks-subnet"].id
  aks_role_based_access_control_enabled = true
  aks_default_node_pool_name            = "default"
  aks_dns_prefix                        = "demo"
  aks_node_disk_size                    = 30
  aks_node_count                        = 2
  aks_vm_size                           = "Standard_DS2_v2"
  aks_cluster_name                      = "demo-${var.environment}-aks"

}
