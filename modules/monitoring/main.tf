resource "google_logging_project_sink" "sink" {
  project     = var.project_id
  name        = "lz-log-sink"
  destination = var.sink_destination
  filter      = "resource.type=global"
}