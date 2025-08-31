# Management VPC (for shared resources)
resource "google_compute_network" "mgmt_vpc" {
  project                 = var.host_project_id
  name                    = "mgmt-vpc"
  auto_create_subnetworks = false
}

# Development VPC
resource "google_compute_network" "dev_vpc" {
  project                 = var.service_projects[0]
  name                    = "dev-vpc" 
  auto_create_subnetworks = false
}

# Development subnet
resource "google_compute_subnetwork" "dev_subnet" {
  project       = var.service_projects[0]
  name          = "dev-subnet"
  ip_cidr_range = "10.1.0.0/24"
  region        = "us-central1"
  network       = google_compute_network.dev_vpc.id
  
  private_ip_google_access = true
}

# Basic firewall - allow internal traffic in dev
resource "google_compute_firewall" "dev_allow_internal" {
  project = var.service_projects[0]
  name    = "allow-internal"
  network = google_compute_network.dev_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }
  
  source_ranges = [google_compute_subnetwork.dev_subnet.ip_cidr_range]
}

# Allow SSH from anywhere (for demo purposes)
resource "google_compute_firewall" "dev_allow_ssh" {
  project = var.service_projects[0]
  name    = "allow-ssh"
  network = google_compute_network.dev_vpc.name
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  source_ranges = ["0.0.0.0/0"]
}