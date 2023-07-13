output "primary_access_key" {
  value     = module.storage-account.primary_access_key
  sensitive = true
}
