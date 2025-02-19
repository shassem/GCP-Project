resource "google_compute_instance" "privatevm" {
  name         = "privatevm"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  tags = ["myinst"]

  boot_disk {
    initialize_params {
      image = var.vm_image
      labels = {
        my_label = "value"
      }
    }
  }

  network_interface {
    network    = module.network.vpc_id
    subnetwork = module.network.management_subnet_id
    network_ip = var.vmprivateip
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.vm_service_account.email
    scopes = ["cloud-platform"]
  }

  #Installing kubectl, dockercli, git, gcloud authentication plugins
  metadata = {
    startup-script = <<-EOF

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    apt-get update -y && apt-get install ca-certificates curl gnupg lsb-release -y && mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update && apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
    apt install git      
    apt-get install google-cloud-sdk-gke-gcloud-auth-plugin

    EOF  
  }


  # depends_on --> To wait for the cluster to be created so the last commands in the metadata can work
  # depends_on = [
  #       google_container_cluster.primary
  #   ]
}

