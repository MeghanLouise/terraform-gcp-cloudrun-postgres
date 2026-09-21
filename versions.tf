terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.30"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # Terraform's local state file would contain the generated DB password,
  # so this module should never be run with local state outside of a quick
  # personal test. Point it at a real backend before using it for anything
  # shared or long-lived:
  #
  # backend "gcs" {
  #   bucket = "YOUR_TERRAFORM_STATE_BUCKET"
  #   prefix = "terraform-gcp-cloudrun-postgres"
  # }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
