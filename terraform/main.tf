terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = var.credentials
  project     = var.project
  region      = var.region
}


resource "google_storage_bucket" "data-lake" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true
}


resource "google_bigquery_dataset" "staging-dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}