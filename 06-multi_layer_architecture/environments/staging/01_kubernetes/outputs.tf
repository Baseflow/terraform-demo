# Output the kubernetes cluster config to re-use in later layers
output "kubernetes_cluster_config" {
  sensitive = true
  value     = module.kubernetes.kubernetes_cluster_config
}
