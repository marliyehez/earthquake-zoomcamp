variable "credentials" {
  description = "My Credentials"
  default     = "~/.gc/service_account.json"
}


variable "project" {
  description = "Project"
  default     = "Your Project Name"
}


variable "region" {
  description = "Region"
  default     = "us-central1"
}


variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default = "US"
}


variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default = "Your Bucket Name"
}


variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default = "Your Dataset Name"
}
