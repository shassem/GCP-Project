# Variable values for the default workspace

cluster_subnet    = "10.0.0.0/24"
management_subnet = "10.0.1.0/24"
cluster_svrole    = "roles/storage.admin"   # Storage Admin
vm_svrole         = "roles/container.admin" # Kubernetes Engine Admin
controlplane_cidr = "172.16.0.0/28"
cluster_cidr      = "192.168.0.0/21"
service_cidr      = "192.168.8.0/27"
work_nodes_no     = 1
vm_image          = "debian-cloud/debian-11"
vmprivateip       = "10.0.1.3"