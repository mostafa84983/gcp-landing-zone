# Management VPC (for shared resources)
# https://cloud.google.com/compute/docs/virtual-networks
resource "google_compute_network" "mgmt_vpc" {
  project                 = var.host_project_id
  name                    = "mgmt-vpc"
  auto_create_subnetworks = false
}

# Development VPC
# https://cloud.google.com/compute/docs/virtual-networks
resource "google_compute_network" "dev_vpc" {
  project                 = var.service_projects[0]
  name                    = "dev-vpc" 
  auto_create_subnetworks = false
}

# Development subnet
# https://cloud.google.com/compute/docs/subnetworks
resource "google_compute_subnetwork" "dev_subnet" {
  project       = var.service_projects[0]
  name          = "dev-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = var.default_region
  network       = google_compute_network.dev_vpc.id
  
  # https://cloud.google.com/compute/docs/configure-private-google-access
  private_ip_google_access = true
}

# Basic firewall - allow internal traffic in dev
# https://cloud.google.com/compute/docs/firewalls
resource "google_compute_firewall" "dev_allow_internal" {
  project = var.service_projects[0]
  name    = "allow-internal"
  network = google_compute_network.dev_vpc.name
  
  # https://cloud.google.com/compute/docs/firewalls-rules
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  
  # https://cloud.google.com/compute/docs/subnetworks#subnetworks_and_routes
  source_ranges = [google_compute_subnetwork.dev_subnet.ip_cidr_range]
}

# Allow SSH from anywhere (for demo purposes)
# https://cloud.google.com/compute/docs/firewalls
resource "google_compute_firewall" "dev_allow_ssh" {
  project = var.service_projects[0]
  name    = "allow-ssh"
  network = google_compute_network.dev_vpc.name
  
  # https://cloud.google.com/compute/docs/firewalls-rules
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  # https://cloud.google.com/compute/docs/subnetworks#subnetworks_and_routes
  source_ranges = ["0.0.0.0/0"]
}

