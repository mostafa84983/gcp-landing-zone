# Simple Cloud Storage bucket for centralized logging
resource "google_storage_bucket" "logging_bucket" {
  project  = var.mgmt_project_id
  name     = "${var.mgmt_project_id}-logs"
  location = "US"
  
  uniform_bucket_level_access = true
  
  # Simple lifecycle - delete logs after 90 days
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
}

# Basic logging sink for management project
resource "google_logging_project_sink" "mgmt_sink" {
  project     = var.mgmt_project_id
  name        = "centralized-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logging_bucket.name}"
  filter      = "severity >= ERROR"
  
  unique_writer_identity = true
}

# Basic logging sink for dev project
resource "google_logging_project_sink" "dev_sink" {
  project     = var.dev_project_id
  name        = "centralized-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.logging_bucket.name}"
  filter      = "severity >= WARNING"
  
  unique_writer_identity = true
}

# Grant bucket write permissions
resource "google_storage_bucket_iam_member" "mgmt_sink_writer" {
  bucket = google_storage_bucket.logging_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.mgmt_sink.writer_identity
}

resource "google_storage_bucket_iam_member" "dev_sink_writer" {
  bucket = google_storage_bucket.logging_bucket.name
  role   = "roles/storage.objectCreator"
  member = google_logging_project_sink.dev_sink.writer_identity
}
