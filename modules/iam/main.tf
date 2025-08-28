resource "google_service_account" "sa" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "Landing Zone Admin SA"
}

resource "google_project_iam_binding" "sa_roles" {
  for_each = toset([
    "roles/compute.networkAdmin",
    "roles/resourcemanager.projectIamAdmin",
    "roles/logging.admin"
  ])
  project = var.project_id
  role    = each.key
  members = ["serviceAccount:${google_service_account.sa.email}"]
}

resource "google_project_iam_binding" "admin" {
  project = var.project_id
  role    = "roles/owner"
  members = ["user:${var.admin_email}"]
}