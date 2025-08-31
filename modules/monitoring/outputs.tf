output "logging_bucket_name" {
  description = "Centralized logging bucket"
  value       = google_storage_bucket.logging_bucket.name
}

output "logging_sinks" {
  description = "Created logging sinks"
  value = {
    mgmt = google_logging_project_sink.mgmt_sink.name
    dev  = google_logging_project_sink.dev_sink.name
  }
}
