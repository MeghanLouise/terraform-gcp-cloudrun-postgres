terraform {
  required_version = ">= 1.5.0"

  # Bucket intentionally omitted here - CI supplies it at init time with
  # `terraform init -backend-config="bucket=..."` so the bucket name isn't
  # hardcoded into a tracked file. See the README's CI/CD section.
  backend "gcs" {}
}

module "app" {
  source = "../../"

  project_id = var.project_id
  region     = var.region
  name       = "example-app"

  # Swap in your own image once you have one, e.g.:
  # container_image = "us-docker.pkg.dev/my-project/my-repo/my-app:latest"
  # Left unset here so `terraform apply` succeeds immediately using
  # Google's Cloud Run hello-world sample as the default.

  allow_unauthenticated = true
}

output "cloud_run_url" {
  value = module.app.cloud_run_url
}
