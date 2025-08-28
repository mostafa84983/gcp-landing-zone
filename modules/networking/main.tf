# Create Shared VPC host project
resource "google_compute_shared_vpc_host_project" "host" {
  project = var.host_project_id
}

# Attach service projects to Shared VPC
resource "google_compute_shared_vpc_service_project" "service" {
  for_each        = toset(var.service_project_ids)
  host_project    = var.host_project_id
  service_project = each.key
}

# Create VPC
resource "google_compute_network" "vpc" {
  project                 = var.host_project_id
  name                    = var.vpc_name
  auto_create_subnetworks = false
}

# Create subnet
resource "google_compute_subnetwork" "subnet" {
  project       = var.host_project_id
  name          = "${var.vpc_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.subnet_region
  network       = google_compute_network.vpc.id
}

# Firewall rule to allow SSH (port 22)
resource "google_compute_firewall" "allow_ssh" {
  project     = var.host_project_id
  name        = "${var.vpc_name}-allow-ssh"
  network     = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Adjust to specific CIDR for production
}

# Firewall rule to allow HTTP (port 80)
resource "google_compute_firewall" "allow_http" {
  project     = var.host_project_id
  name        = "${var.vpc_name}-allow-http"
  network     = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"] # Adjust to specific CIDR for production
}

# Firewall rule to allow HTTPS (port 443)
resource "google_compute_firewall" "allow_https" {
  project     = var.host_project_id
  name        = "${var.vpc_name}-allow-https"
  network     = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"] # Adjust to specific CIDR for production
}

# Firewall rule to allow internal traffic
resource "google_compute_firewall" "allow_internal" {
  project     = var.host_project_id
  name        = "${var.vpc_name}-allow-internal"
  network     = google_compute_network.vpc.id
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "icmp"
  }
  source_ranges = [var.subnet_cidr]
}