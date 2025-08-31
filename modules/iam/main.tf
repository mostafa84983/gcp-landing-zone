# Service account for dev workloads
resource "google_service_account" "dev_sa" {
  project      = var.dev_project_id
  account_id   = "dev-compute"
  display_name = "Development Service Account"
}

# Service account for monitoring
resource "google_service_account" "monitoring_sa" {
  project      = var.mgmt_project_id
  account_id   = "monitoring"
  display_name = "Monitoring Service Account"
}

# Dev SA permissions
resource "google_project_iam_member" "dev_sa_compute" {
  project = var.dev_project_id
  role    = "roles/compute.instanceAdmin"
  member  = "serviceAccount:${google_service_account.dev_sa.email}"
}

resource "google_project_iam_member" "dev_sa_logging" {
  project = var.dev_project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.dev_sa.email}"
}

# Monitoring SA permissions
resource "google_project_iam_member" "monitoring_sa_logging" {
  project = var.mgmt_project_id
  role    = "roles/logging.admin"
  member  = "serviceAccount:${google_service_account.monitoring_sa.email}"
}