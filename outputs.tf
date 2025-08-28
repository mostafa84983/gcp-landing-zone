output "mgmt_project_id" {
  value = module.mgmt_project.project_id
}

output "prod_project_id" {
  value = module.prod_project.project_id
}

output "dev_project_id" {
  value = module.dev_project.project_id
}

output "vpc_name" {
  value = module.networking.vpc_name
}

output "service_account_email" {
  value = module.iam.service_account_email
}