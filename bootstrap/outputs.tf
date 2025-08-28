output "tf_state_bucket" {
  value = google_storage_bucket.tf_state.name
}

output "log_bucket" {
  value = google_storage_bucket.log_bucket.name
}

output "tf_admin_service_account_email" {
  value = google_service_account.tf_admin.email
}

output "tf_admin_service_account_key" {
  value     = google_service_account_key.tf_admin_key.private_key
  sensitive = true
}