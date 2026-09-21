resource "random_password" "db" {
  length  = 24
  special = false
}

resource "google_sql_database_instance" "this" {
  name             = "${var.name}-pg"
  database_version = var.db_version
  region           = var.region

  settings {
    tier              = var.db_tier
    availability_type = var.db_high_availability ? "REGIONAL" : "ZONAL"

    ip_configuration {
      # No public IP at all - the instance is only reachable from inside
      # the VPC we just built (which is exactly how Cloud Run reaches it,
      # via direct VPC egress in cloudrun.tf).
      ipv4_enabled    = false
      private_network = google_compute_network.this.id
    }

    backup_configuration {
      enabled = true
    }
  }

  deletion_protection = var.deletion_protection

  # Cloud SQL can't attach a private IP until the peering connection from
  # network.tf actually exists.
  depends_on = [google_service_networking_connection.this]
}

resource "google_sql_database" "this" {
  name     = var.db_name
  instance = google_sql_database_instance.this.name
}

resource "google_sql_user" "this" {
  name     = var.db_user
  instance = google_sql_database_instance.this.name
  password = random_password.db.result
}
