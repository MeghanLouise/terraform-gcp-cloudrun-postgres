variable "project_id" {
  description = "GCP project ID to deploy into."
  type        = string
}

variable "region" {
  description = "GCP region for all resources."
  type        = string
  default     = "us-central1"
}

variable "name" {
  description = "Short name used as a prefix for every resource this module creates (e.g. \"myapp\")."
  type        = string
}

variable "container_image" {
  description = "Container image for the Cloud Run service. Defaults to Google's hello-world sample so the module is usable out of the box; override with your own image once you have one."
  type        = string
  default     = "us-docker.pkg.dev/cloudrun/container/hello"
}

variable "cloud_run_cpu" {
  description = "CPU limit for the Cloud Run container."
  type        = string
  default     = "1"
}

variable "cloud_run_memory" {
  description = "Memory limit for the Cloud Run container."
  type        = string
  default     = "512Mi"
}

variable "min_instance_count" {
  description = "Minimum number of Cloud Run instances. 0 allows scale-to-zero."
  type        = number
  default     = 0
}

variable "max_instance_count" {
  description = "Maximum number of Cloud Run instances."
  type        = number
  default     = 2
}

variable "allow_unauthenticated" {
  description = "If true, grants roles/run.invoker to allUsers so the service is publicly reachable over the internet. Leave false for internal/service-to-service APIs."
  type        = bool
  default     = false
}

variable "authorized_invoker_members" {
  description = "IAM members (e.g. \"serviceAccount:caller@project.iam.gserviceaccount.com\") granted roles/run.invoker, for server-to-server callers. Independent of allow_unauthenticated."
  type        = list(string)
  default     = []
}

variable "subnet_cidr" {
  description = "CIDR range for the VPC subnet that Cloud Run's direct VPC egress uses."
  type        = string
  default     = "10.10.0.0/24"
}

variable "db_version" {
  description = "Cloud SQL Postgres version."
  type        = string
  default     = "POSTGRES_15"
}

variable "db_tier" {
  description = "Cloud SQL machine tier."
  type        = string
  default     = "db-custom-1-3840"
}

variable "db_high_availability" {
  description = "If true, deploys the Cloud SQL instance as REGIONAL (HA, standby in a second zone) instead of ZONAL."
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Name of the application database created inside the instance."
  type        = string
  default     = "app"
}

variable "db_user" {
  description = "Name of the application database user."
  type        = string
  default     = "app"
}

variable "deletion_protection" {
  description = "If true, Terraform refuses to destroy the Cloud SQL instance. Set to false only in throwaway/dev environments."
  type        = bool
  default     = true
}
