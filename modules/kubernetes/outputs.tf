output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kubernetes_cluster_config" {
  sensitive = true
  value     = azurerm_kubernetes_cluster.aks.kube_config
}
