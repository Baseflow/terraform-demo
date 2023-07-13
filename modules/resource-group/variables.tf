# there is no default, a value MUST be provided by either the *.tfvars file, or
# a prompt will be given to the user
variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

# Setting the default value will not ask/prompt the user for input, but will
# fall back to this value if no other value is specified in the *.tfvars file
variable "resource_group_location" {
  description = "The location the resource group resides"
  type        = string
  default     = "westeurope"
}
