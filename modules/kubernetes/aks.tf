resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.aks_dns_prefix

  role_based_access_control_enabled = var.aks_role_based_access_control_enabled
  node_resource_group               = "${var.resource_group_name}-aks-nodes"

  default_node_pool {
    name            = var.aks_default_node_pool_name
    node_count      = var.aks_node_count
    vm_size         = var.aks_vm_size
    os_disk_size_gb = var.aks_node_disk_size
    # the aks cluster can be deployed into the existing virtual network. 
    vnet_subnet_id = var.aks_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }
}
