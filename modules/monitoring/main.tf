# Create a Cloud Storage bucket for centralized logging
# https://cloud.google.com/logging/docs/storage-logging
resource "google_storage_bucket" "logging_bucket" {
  project  = var.mgmt_project_id
  name     = "${var.mgmt_project_id}-logs"
  location = "US"
  
  uniform_bucket_level_access = true
  
  # Delete logs after 90 days
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

# Create a logging sink for the management project
# https://cloud.google.com/logging/docs/export/configure_export_v2
resource "google_logging_project_sink" "mgmt_sink" {
  project     = var.mgmt_project_id
  name        = "centralized-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logging_bucket.name}"
  filter      = "severity >= ERROR"
  
  unique_writer_identity = true
}

# Create a logging sink for the development project
# https://cloud.google.com/logging/docs/export/configure_export_v2
resource "google_logging_project_sink" "dev_sink" {
  project     = var.dev_project_id
  name        = "centralized-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logging_bucket.name}"
  filter      = "severity >= WARNING"
  
  unique_writer_identity = true
}

# Grant the management sink writer permissions
# https://cloud.google.com/iam/docs/service-accounts
resource "google_storage_bucket_iam_member" "mgmt_sink_writer" {
  bucket = google_storage_bucket.logging_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.mgmt_sink.writer_identity
}

# Grant the development sink writer permissions
# https://cloud.google.com/iam/docs/service-accounts
resource "google_storage_bucket_iam_member" "dev_sink_writer" {
  bucket = google_storage_bucket.logging_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.dev_sink.writer_identity
}

