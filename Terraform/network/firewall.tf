resource "google_compute_firewall" "allow_ssh" {
  name        = "allow-ssh"
  network     = google_compute_network.myvpc.id
  description = "Creates firewall rule to allow ssh and HTTP"
  direction = "INGRESS"
  source_ranges = ["35.235.240.0/20"]       #IAP CIDR

  allow {
    protocol  = "tcp"
    ports     = ["22", "80"]
  }

  source_tags = ["myinst"]
}

# #Denying access to internet on all the VPC
# resource "google_compute_firewall" "deny_internet" {
#   name        = "stop-internet"
#   network     = google_compute_network.myvpc.id
#   description = "Creates firewall rule to disallow internet access"
#   direction = "EGRESS"
#   destination_ranges = ["0.0.0.0/0"]

#   deny {
#     protocol  = "all"
#   }

# #   target_tags = ["web"]
# }
# # Allowing egress for health check
# resource "google_compute_firewall" "health_check" {
#   name        = "hlth-check"
#   network     = google_compute_network.myvpc.id
#   description = "Creates firewall rule to disallow internet access"
#   direction = "EGRESS"
#   priority = "800"
#   destination_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22", "169.254.169.254"]

#   allow {
#     protocol  = "all"
#   }

# #   target_tags = ["web"]
# }
# #Allowing full egress access from only the private instance
# resource "google_compute_firewall" "allow_internet" {
#   name        = "internet-for-vm"
#   network     = google_compute_network.myvpc.id
#   description = "Creates firewall rule to allow internet access from the VM"
#   direction = "EGRESS"
#   priority = "800"
#   destination_ranges = ["0.0.0.0/0"]

#   allow {
#     protocol  = "all"
#   }

#   target_tags = ["myinst"]
# }