# A private VPC that Cloud Run and Cloud SQL both sit in, so the database
# is never reachable from the public internet.

resource "google_compute_network" "this" {
  name                    = "${var.name}-vpc"
  auto_create_subnetworks = false

  depends_on = [google_project_service.this]
}

resource "google_compute_subnetwork" "this" {
  name          = "${var.name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.this.id
}

# Cloud SQL's private IP isn't handed out from our subnet - it comes from a
# separate range that we reserve and then hand over to Google's own
# "service producer" network via VPC peering. This is Google-managed
# infrastructure sitting logically alongside our VPC, not inside it.
resource "google_compute_global_address" "private_service_range" {
  name          = "${var.name}-private-service-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.this.id
}

resource "google_service_networking_connection" "this" {
  network                 = google_compute_network.this.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_service_range.name]
}
