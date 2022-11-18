# GCP with Terraform and GKE

Creating a Google Cloud Platform (GCP) infrastructure using Terraform (IaC) to build an application and deploying on Google Container Cluster (GKE)

I used a private VM Instance to connect to an all-private GKE Cluster. 

## Illustrations
### Requirements
- Private VM to connect to the GKE cluster which is in the same VPC
- Private VM with custom service account that has Kubernetes Admin permission to access cluster resources and Storage Admin in order to have full control of Google Cloud Storage (GCS) resources.
- Cluster with custom service account that has Storage Admin permissions so it can pull the image from GCR.

All work is applied on a single GCP project and region: us-central1. <br />
Variables can be changed.

### Terraform
Backend bucket to store the state file as an object that can be accessed by the users working on the same project.

Network module that setups VPC Network with two subnets and the rest necessary configurations as shown below:
- Management subnet (Instance) / Restricted subnet (Cluster)
- NAT service for the private instance
- Firewall that allows SSH to the instance

Adding a start-up script to the instance that installs:
- Docker --> to build/push images.
- kubectl --> to apply kubernetes commands on the cluster.
- gcloud authentication plugin --> to extend kubectl’s authentication to support GKE.
- git --> to clone the repository

Standard Google Container Cluster service with private control plane and working nodes. Letting the VM instance the only authorized instance to connect to the cluster.

## Steps
### Building the image
SSH to the created instance through IAP tunneling from the local machine or the GUI Cloud Shell. <br />
Then clone the repo

```bash
    git clone https://github.com/shassem/GCP-Project.git
```
We should dockerize the application in able to deploy it as a container, here comes the use of the Dockerfile. <br />
Dockerfile has all the requirements needed to run the application. <br />
Now we should build it and push the image to GCR, but before pushing the image we should authenticate the service account in order to push, so we are going to use a command that will obtain a short lived token in order to authenticate successfully

```bash
    docker build -t gcr.io/gcp-project-368920/gcproject .

    gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://gcr.io

    docker push gcr.io/gcp-project-368920/gcproject
```
In order this application to work, we need a redis container to be working as a backend app, and since we are going to use Kubernetes containers, we will run both redis and the app as deployments each.

We should pull the redis image first and push it to GCR, as the cluster has no access to internet.

```bash
    docker pull redis
    docker tag redis gcr.io/gcp-project-368920/redis
    docker push gcr.io/gcp-project-368920/redis
```

### Deploying the application

We need to create redis pods with a Cluster IP service attached to it. <br />
And we should create the app pods with a Loadbalancer service in order to access it externally.

```bash
    kubectl apply -f redis.yml
    kubectl apply -f deployment.yml
```
Now use the external IP of the Loadbalancer and add to the URL the specified port (8000).

### Voila! The application is now working!🚀