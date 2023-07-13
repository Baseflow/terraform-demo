variable "aks_node_count" {
  description = "The number of nodes within the aks cluster."
  type        = number
}

variable "aks_vm_size" {
  description = "The size of the virtual machines to use within the aks cluster."
  type        = string
}

variable "aks_node_disk_size" {
  description = "The node disk size in GB to use within the cluster."
  type        = number
}

variable "aks_cluster_name" {
  description = "The name of the aks cluster."
  type        = string
}

variable "aks_dns_prefix" {
  description = "The dnf prefix to use within the aks cluster."
  type        = string
}

variable "aks_default_node_pool_name" {
  description = "The name of the default node pool."
  type        = string
}

variable "aks_role_based_access_control_enabled" {
  description = "Defines whether role based access control within the aks cluster is enables (default true)."
  type        = bool
}

variable "resource_group_name" {
  description = "The resource group name where the custer resides in"
  type        = string
}

variable "resource_group_location" {
  description = "The resource group location where the custer resides in"
  type        = string
}

variable "aks_subnet_id" {
  description = "The subnet to have the aks nodes reside in"
  type        = string
}
