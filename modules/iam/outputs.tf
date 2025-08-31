output "service_accounts" {
  description = "Created service accounts"
  value = {
    dev_compute = google_service_account.dev_sa.email
    monitoring  = google_service_account.monitoring_sa.email
  }
}
