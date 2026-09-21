locals {
  required_apis = [
    "run.googleapis.com",
    "sqladmin.googleapis.com",
    "servicenetworking.googleapis.com",
    "secretmanager.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]
}

resource "google_project_service" "this" {
  for_each = toset(local.required_apis)

  project = var.project_id
  service = each.value

  # Destroying this module should never disable an API project-wide -
  # something else in the project may depend on it.
  disable_on_destroy = false
}
