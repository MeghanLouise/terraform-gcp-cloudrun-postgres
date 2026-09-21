# The generated DB password lives in Secret Manager, not as a plain Cloud
# Run environment variable - env vars show up in plaintext in the console,
# in `gcloud run services describe`, and in deployment logs. Secret Manager
# references don't.

resource "google_secret_manager_secret" "db_password" {
  secret_id = "${var.name}-db-password"

  replication {
    auto {}
  }

  depends_on = [google_project_service.this]
}

resource "google_secret_manager_secret_version" "db_password" {
  secret      = google_secret_manager_secret.db_password.id
  secret_data = random_password.db.result
}
