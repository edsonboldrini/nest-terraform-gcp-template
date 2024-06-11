locals {
  name    = "nest-terraform-gcp-template"
  project = "personal"
  region  = "us-east1"
}

provider "google" {
  project = local.project
  region  = local.region
}

resource "random_id" "default" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name                        = "${local.name}-gcf-source-${random_id.default.hex}" # Every bucket name must be globally unique
  location                    = local.region
  uniform_bucket_level_access = true
}

data "archive_file" "default" {
  type        = "zip"
  source_dir  = "../dist"
  output_path = "/tmp/function-source.zip"
}

resource "google_storage_bucket_object" "object" {
  name   = "function-source.zip"
  bucket = google_storage_bucket.default.name
  source = data.archive_file.default.output_path
}

resource "google_cloudfunctions2_function" "default" {
  name     = local.name
  location = local.region

  build_config {
    runtime     = "nodejs20"
    entry_point = "main"
    source {
      storage_source {
        bucket = google_storage_bucket.default.name
        object = google_storage_bucket_object.object.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}

resource "google_cloud_run_service_iam_member" "member" {
  location = google_cloudfunctions2_function.default.location
  service  = google_cloudfunctions2_function.default.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

output "function_uri" {
  value = google_cloudfunctions2_function.default.service_config[0].uri
}
