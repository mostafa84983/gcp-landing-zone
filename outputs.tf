output "mgmt_project_id" {
  value = module.mgmt_project.project_id
}

output "dev_project_id" {
  value = module.dev_project.project_id
}

output "networks" {
  value = module.networking.network_name
}

output "service_accounts" {
  value = module.iam.service_accounts
}

output "logging_bucket" {
  value = module.monitoring.logging_bucket_name
}
