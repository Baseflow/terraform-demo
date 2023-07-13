# Access keys contain sensitive data and must have the 'sensitive' property set to 'true'
output "demo-primary_access_key" {
  value     = module.storage-account-demo.primary_access_key
  sensitive = true
}

# Access keys contain sensitive data and must have the 'sensitive' property set to 'true'
output "non-demo-primary_access_key" {
  value     = module.storage-account-non-demo.primary_access_key
  sensitive = true
}
