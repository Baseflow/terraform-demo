terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.55.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate883210"
    container_name       = "tfstate"
    key                  = "demo/mla/staging/application.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# Get output state from our kubernets state file
data "terraform_remote_state" "kubernetes" {
  backend = "azurerm"
  config = {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstate883210"
    container_name       = "tfstate"
    key                  = "demo/mla/staging/kubernetes.tfstate"
  }
}

# The kubernetes layer contains credentials and certificates 
# for the newly created cluster. Use these to configure the kubernetes provider 
# in order to communicate with the correct cluster we just created.
provider "kubernetes" {
  host                   = data.terraform_remote_state.kubernetes.outputs.kubernetes_cluster_config[0].host
  client_certificate     = base64decode(data.terraform_remote_state.kubernetes.outputs.kubernetes_cluster_config[0].client_certificate)
  client_key             = base64decode(data.terraform_remote_state.kubernetes.outputs.kubernetes_cluster_config[0].client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.kubernetes.outputs.kubernetes_cluster_config[0].cluster_ca_certificate)
}


# Deploy the application module
module "application" {
  source = "../../../../modules/application/"
  title  = "Welcome to Azure Kubernetes Service (AKS)"
}
