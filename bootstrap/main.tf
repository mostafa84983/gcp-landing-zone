provider "google" {
  project = var.bootstrap_project_id
  region  = var.region
}

# Create GCS bucket for Terraform state
resource "google_storage_bucket" "tf_state" {
  name          = var.tf_state_bucket
  location      = var.region
  force_destroy = false

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

# Create GCS bucket for logs
resource "google_storage_bucket" "log_bucket" {
  name          = var.log_bucket
  location      = var.region
  force_destroy = false

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
}

# Create service account for Terraform
resource "google_service_account" "tf_admin" {
  account_id   = "tf-state-admin"
  display_name = "Terraform State Admin"
}

# Grant service account access to state bucket
resource "google_storage_bucket_iam_binding" "tf_state_access" {
  bucket = google_storage_bucket.tf_state.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.tf_admin.email}"
  ]
}

# Grant service account access to log bucket
resource "google_storage_bucket_iam_binding" "log_bucket_access" {
  bucket = google_storage_bucket.log_bucket.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.tf_admin.email}"
  ]
}

# Grant service account project-level permissions
resource "google_project_iam_binding" "tf_admin_roles" {
  for_each = toset([
    "roles/compute.networkAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.admin"
    # "roles/owner"
  ])
  project = var.bootstrap_project_id
  role    = each.key
  members = ["serviceAccount:${google_service_account.tf_admin.email}"]
}

# Export service account key for GitHub Actions
resource "google_service_account_key" "tf_admin_key" {
  service_account_id = google_service_account.tf_admin.name
}