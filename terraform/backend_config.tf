terraform {
  required_version = ">= 1.6.4"
  backend "gcs" {
    bucket = "terraform-nest"
    prefix = "/cloud-functions/nest-terraform-gcp-template"
  }
}