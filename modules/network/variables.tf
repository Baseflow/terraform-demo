variable "vnet_address_space" {
  description = "The address space for the aks VNET"
  type        = string
}

variable "vnet_name" {
  description = "The name of the VNET"
  type        = string
}

variable "subnets" {
  description = "The subnets to create within the VNET"
  type = list(object({
    name           = string,
    address_prefix = string
  }))
}

variable "resource_group_name" {
  description = "The resource group name where the custer resides in"
  type        = string
}

variable "resource_group_location" {
  description = "The resource group location where the custer resides in"
  type        = string
}
