output "cloud_run_url" {
  description = "Public URL of the deployed Cloud Run service."
  value       = google_cloud_run_v2_service.this.uri
}

output "cloud_run_service_account_email" {
  description = "Email of the service account Cloud Run runs as."
  value       = google_service_account.cloud_run.email
}

output "cloud_sql_connection_name" {
  description = "Cloud SQL instance connection name (project:region:instance)."
  value       = google_sql_database_instance.this.connection_name
}

output "cloud_sql_private_ip" {
  description = "Private IP address of the Cloud SQL instance."
  value       = google_sql_database_instance.this.private_ip_address
}

output "db_password_secret_id" {
  description = "Secret Manager secret ID holding the generated DB password."
  value       = google_secret_manager_secret.db_password.secret_id
}
