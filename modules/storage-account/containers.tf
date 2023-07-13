resource "azurerm_storage_container" "unicon_cdn_storage_container" {
  depends_on            = [azurerm_storage_account.storage_account]
  for_each              = { for each in var.containers : each.name => each }
  name                  = each.value.name
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = each.value.access_type
}
