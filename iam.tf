# A dedicated identity for the running service, instead of the wide-open
# Compute Engine default service account most projects fall back to.
resource "google_service_account" "cloud_run" {
  account_id   = "${var.name}-run-sa"
  display_name = "Cloud Run runtime SA for ${var.name}"
}

# The only permission the service needs beyond running code: read the one
# secret holding its own DB password.
resource "google_secret_manager_secret_iam_member" "cloud_run_reads_db_password" {
  secret_id = google_secret_manager_secret.db_password.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloud_run.email}"
}

# Explicit allow-list of callers (e.g. another service account) that may
# invoke this service directly, regardless of allow_unauthenticated.
resource "google_cloud_run_v2_service_iam_member" "invoker" {
  for_each = toset(var.authorized_invoker_members)

  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  member   = each.value
}

# Opt-in public access. Off by default - a database-backed service should
# not be world-invokable unless you mean it to be.
resource "google_cloud_run_v2_service_iam_member" "public" {
  count = var.allow_unauthenticated ? 1 : 0

  name     = google_cloud_run_v2_service.this.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
