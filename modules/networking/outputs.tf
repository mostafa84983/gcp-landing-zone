output "network_self_link" {
  description = "VPC network links"
  value = {
    mgmt = google_compute_network.mgmt_vpc.self_link
    dev  = google_compute_network.dev_vpc.self_link
  }
}

output "network_name" {
  description = "VPC network names"
  value = {
    mgmt = google_compute_network.mgmt_vpc.name
    dev  = google_compute_network.dev_vpc.name
  }
}

output "subnets" {
  description = "Created subnets"
  value = {
    dev-subnet = {
      name          = google_compute_subnetwork.dev_subnet.name
      ip_cidr_range = google_compute_subnetwork.dev_subnet.ip_cidr_range
      self_link     = google_compute_subnetwork.dev_subnet.self_link
    }
  }
}
