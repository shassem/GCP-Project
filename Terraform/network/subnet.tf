resource "google_compute_subnetwork" "restricted_subnet" {
  name                     = "restrict-sub"
  ip_cidr_range            = var.cluster_subnet
  region                   = "us-central1"
  network                  = google_compute_network.myvpc.id
  private_ip_google_access = true
}


resource "google_compute_subnetwork" "management_subnet" {
  name                     = "mng-sub"
  ip_cidr_range            = var.management_subnet
  region                   = "us-central1"
  network                  = google_compute_network.myvpc.id
  private_ip_google_access = true
}