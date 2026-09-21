resource "google_cloud_run_v2_service" "this" {
  name     = "${var.name}-service"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.cloud_run.email

    scaling {
      min_instance_count = var.min_instance_count
      max_instance_count = var.max_instance_count
    }

    # Direct VPC egress: lets this service reach the private IP of Cloud
    # SQL without a separate Serverless VPC Access connector resource.
    vpc_access {
      network_interfaces {
        network    = google_compute_network.this.id
        subnetwork = google_compute_subnetwork.this.id
      }

      # Only traffic to RFC1918 (private) ranges is routed through the VPC.
      # Everything else - pulling the container image, calling other Google
      # APIs - still takes Cloud Run's normal, faster path.
      egress = "PRIVATE_RANGES_ONLY"
    }

    containers {
      image = var.container_image

      resources {
        limits = {
          cpu    = var.cloud_run_cpu
          memory = var.cloud_run_memory
        }
      }

      env {
        name  = "DB_HOST"
        value = google_sql_database_instance.this.private_ip_address
      }

      env {
        name  = "DB_NAME"
        value = google_sql_database.this.name
      }

      env {
        name  = "DB_USER"
        value = google_sql_user.this.name
      }

      # Resolved from Secret Manager at container start, never stored as
      # plaintext in the Cloud Run revision config.
      env {
        name = "DB_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.db_password.secret_id
            version = "latest"
          }
        }
      }
    }
  }

  depends_on = [google_project_service.this]
}
