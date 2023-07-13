# we can also make our inputs smarter by validating the set values before applying.
variable "storage_account_tier" {
  description = "The SKU tier to set for the azure storage account"
  type        = string
  validation {
    condition     = contains(["Standard", "Premium"], var.storage_account_tier)
    error_message = "Allowed values for storage_account_tier are \"Standard\" or \"Premium\"."
  }
}

variable "storage_account_replication_type" {
  description = "The replication type to use for the azure storage account"
  type        = string
  validation {
    condition     = contains(["LRS", "GRS", "RAGRS", "ZRS", "GZRS", "RAGZRS"], var.storage_account_replication_type)
    error_message = "Allowed values for storage_account_tier are \"LRS\", \"GRS\", \"RAGRS\", \"ZRS\", \"GZRS\", or \"RAGZRS\"."
  }
}

# We can also declare arrays/lists and complex types
variable "containers" {
  description = "A list of containers and corresponding access-types to deploy within the storage account"
  type = list(object({
    name        = string,
    access_type = string
  }))
}

variable "resource_group_name" {
  description = "The name of the resource group to place the storage account in"
  type        = string
}

variable "resource_group_location" {
  description = "The location the resource group to place the storage account in."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}
