# Create the project
resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"
}

# Enable APIs
resource "google_project_service" "services" {
  for_each = toset(var.services)
  
  project = google_project.project.project_id
  service = each.value
  
  disable_on_destroy = false
  
  depends_on = [google_project.project]
}
