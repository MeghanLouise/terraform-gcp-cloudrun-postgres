variable "project_id" {
  description = "GCP project ID to deploy the example into."
  type        = string
}

variable "region" {
  description = "GCP region."
  type        = string
  default     = "us-central1"
}
