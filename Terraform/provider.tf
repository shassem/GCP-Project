provider "google" {
  project     = "gcp-project-368920"
  region      = "us-central1"
}

#To let the team work on the same terraform.tfstate file + state locking
#First create a bucket manually from the GUI with the same ID
terraform {
  backend "gcs" {
    bucket = "shereef-bucket00"
    prefix = "terraform/state"
  }
}

