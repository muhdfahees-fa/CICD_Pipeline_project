**CI/CD Pipeline for Hello World App (GKE + Terraform + GitHub Actions)**

This project demonstrates a fully automated CI/CD pipeline that builds, containerizes, and deploys a Node.js “Hello World” application to a Google Kubernetes Engine (GKE) cluster using Terraform, Docker, and GitHub Actions.

📘 Overview

The workflow automates the complete deployment lifecycle:

Code pushed to the development branch

When merged into main, the GitHub Actions pipeline is triggered

The pipeline:

Builds the application using npm

Containerizes it using Docker

Pushes the image to Google Artifact Registry (GAR)

Deploys the latest image automatically to the GKE cluster

All secrets and credentials are securely stored in GitHub Secrets.

🧠 Key Components
Component	Purpose
GitHub Actions	Automates build, push, and deploy stages
Docker	Containerizes the Node.js application
Google Artifact Registry	Stores the built Docker images
Google Kubernetes Engine (GKE)	Hosts and manages the containerized app
Terraform	Provisions and manages GCP resources (Cluster, APIs, etc.)
⚙️ Workflow Summary

Trigger: When the development branch is merged into main

Stages:

Checkout source code

Authenticate with GCP using Service Account

Build Docker image and push to Artifact Registry

Update Kubernetes deployment with new image

Apply Kubernetes manifests (deployment.yaml and service.yaml)

Verify rollout and pod status

🔑 Prerequisites

Before setting up this project, ensure you have:

A Google Cloud Project (with billing enabled)

Artifact Registry and Kubernetes Engine APIs enabled

A Service Account JSON key with proper IAM permissions

Terraform installed for provisioning GKE resources

GitHub Secrets configured:

GCP_SA_KEY → contents of your service account key JSON

PROJECT_ID, GAR_LOCATION, GKE_CLUSTER, etc.

🌐 Deployment Architecture
GitHub Repo (development → main)
        │
        ▼
 GitHub Actions Workflow
        │
        ▼
   Docker Build → Push to GAR
        │
        ▼
     Deploy to GKE
        │
        ▼
   Service (LoadBalancer)
        │
        ▼
   Public URL (HTTP access)

🧩 Tech Stack

Node.js (Express.js)

Docker

Terraform

Google Artifact Registry

Google Kubernetes Engine (GKE)

GitHub Actions

✅ Outcome

Once the workflow runs successfully:

Your app will be live on a public LoadBalancer IP

Accessible via http://<external-ip>

Automatically updates with every merge to main

Monitoring Setup

Monitoring is enabled using Prometheus and Grafana for real-time application and cluster metrics.

Access Grafana

Grafana is deployed in the monitoring namespace.

Service type: LoadBalancer with EXTERNAL-IP. Example:

http://34.14.148.186


Login credentials:

kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
Username: admin

Grafana Dashboards

CPU usage of Hello World pods:

sum(rate(container_cpu_usage_seconds_total{namespace="default", pod=~"hello-world-deployment.*"}[1m])) by (pod)


Memory usage:

sum(container_memory_usage_bytes{namespace="default", pod=~"hello-world-deployment.*"}) by (pod)


Pod restarts:

kube_pod_container_status_restarts_total{namespace="default", pod=~"hello-world-deployment.*"}


Pod status:

kube_pod_status_phase{namespace="default", pod=~"hello-world-deployment.*"}
