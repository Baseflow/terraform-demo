resource "azurerm_subnet" "subnet" {
  for_each             = { for each in var.subnets : each.name => each }
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [each.value.address_prefix]
}
