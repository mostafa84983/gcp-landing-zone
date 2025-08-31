# Create the project
resource "google_project" "project" {
  name            = var.project_name
  project_id      = var.project_id
  billing_account = var.billing_account
  deletion_policy = "DELETE"

  # https://cloud.google.com/resource-manager/docs/creating-managing-projects
}

# Enable APIs
resource "google_project_service" "services" {
  for_each = toset(var.services)

  project = google_project.project.project_id
  service = each.value

  disable_on_destroy = false

  # https://cloud.google.com/service-usage/docs/enable-disable-services
  # https://cloud.google.com/apis/docs/overview
  depends_on = [google_project.project]
}

