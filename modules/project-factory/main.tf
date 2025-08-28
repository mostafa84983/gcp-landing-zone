resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account
  auto_create_network = false # Prevent default VPC creation
}

resource "google_project_service" "apis" {
  for_each = toset(var.enable_apis)
  project  = google_project.project.project_id
  service  = each.key
}