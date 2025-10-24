
# CI/CD Pipeline for Hello World App (GKE + Terraform + GitHub Actions)

This project implements a fully automated CI/CD pipeline that builds, containerizes, scans, and deploys a Node.js **Hello World** application to a **Google Kubernetes Engine (GKE)** cluster using **Terraform, Docker, and GitHub Actions**.

---

## Workflow

- Code pushed to `development` branch.
- Merge to `main` triggers GitHub Actions pipeline.
- Pipeline steps:
  1. Checkout repository
  2. Authenticate with GCP using Service Account
  3. Build Docker image with **versioning** (GitHub run number, commit SHA, `latest`)
  4. Scan Docker image using **Trivy** (HIGH & CRITICAL vulnerabilities)
  5. Upload Trivy report to GCS and clean old reports
  6. Push Docker image to **Google Artifact Registry**
  7. Cleanup old Docker images (keeping latest 4)
  8. Get GKE credentials
  9. Update Kubernetes deployment image
  10. Apply Kubernetes manifests (`deployment.yaml`, `service.yaml`, `ingress.yaml`)
  11. Verify rollout and pod status
  12. Optional Slack notification

---

## GitHub Secrets

| Secret               | Description |
|----------------------|-------------|
| `GCP_SA_KEY`         | Service Account JSON key |
| `GCP_PROJECT_ID`     | Google Cloud Project ID |
| `GKE_CLUSTER_NAME`   | GKE Cluster name |
| `GKE_ZONE`           | GKE region/zone |
| `GCP_ARTIFACT_REPO`  | Artifact Registry repository |
| `GCS_BUCKET_NAME`    | GCS bucket for Trivy reports |
| `SLACK_BOT_TOKEN`    | Optional Slack bot token for notifications |

Put service account JSON in the same folder as terraform-key.json. That service account must have enough rights to:
enable APIs (roles/serviceusage.serviceUsageAdmin or project owner)

create networks, subnets, GKE clusters, node pools and IAM (compute & container admin, network admin). For production, follow least privilege patterns.

Initialize and apply:

terraform init
terraform apply


After apply completes, run the kubeconfig command printed by the kubeconfig_command output or:

gcloud container clusters get-credentials terraform-gke-cluster --region asia-south1 --project firm-pentameter-475405-i2
kubectl get nodes
kubectl get svc -n ingress-nginx


Wait a minute or two for the LoadBalancer IP to appear. You can check the output ingress_service_external_ips or kubectl get svc -n ingress-nginx until the EXTERNAL-IP is assigned.

---

## Docker Setup and Usage

1. **Build Docker Image** (locally or in pipeline):

```bash
docker build -t hello_world_app:latest ./Hello_world_app
````

2. **Tag for Google Artifact Registry**:

```bash
docker tag hello_world_app:latest asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:latest
```

3. **Push to Artifact Registry**:

```bash
docker push asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:latest
```

4. **Run locally (optional)**:

```bash
docker run -p 3000:3000 hello_world_app:latest
```

---

## Kubernetes Deployment

1. **Get GKE credentials**:

```bash
gcloud container clusters get-credentials <GKE_CLUSTER_NAME> --region <REGION> --project <PROJECT_ID>
```

2. **Apply Kubernetes manifests**:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
```

3. **Update Deployment Image**:

```bash
kubectl set image deployment/hello-world-deployment \
  hello-world=asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:<VERSION>
```

4. **Verify rollout**:

```bash
kubectl rollout status deployment/hello-world-deployment
kubectl get pods
kubectl get svc hello-world-service
kubectl get ingress
```

---

## Terraform Setup and Usage

1. **Initialize Terraform**:

```bash
terraform init
```

2. **Plan Infrastructure**:

```bash
terraform plan
```

3. **Apply Terraform (create GKE cluster, enable APIs, create Artifact Registry)**:

```bash
terraform apply -auto-approve
```

4. **Destroy infrastructure (optional)**:

```bash
terraform destroy -auto-approve
```

> Terraform provisions the GKE cluster, configures required APIs, and creates Artifact Registry and storage buckets for CI/CD.

---

## Docker Versioning

* Images are tagged as:

  * GitHub run number
  * `latest`
  * Commit SHA
* Old images are automatically cleaned (keeping latest 4 versions).

---

## Security Scanning with Trivy

* Scans Docker images for **HIGH** and **CRITICAL** vulnerabilities.
* Reports uploaded to GCS bucket.
* Old reports automatically cleaned (keeping latest 3).

---

## Monitoring with Prometheus & Grafana

* Prometheus monitors application and cluster metrics.
* Grafana provides dashboards.
* Grafana Service type: **LoadBalancer**
* Example access: `http://34.14.148.186`

### Grafana Credentials

=======
---

## Docker Setup and Usage

1. **Build Docker Image** (locally or in pipeline):

```bash
docker build -t hello_world_app:latest ./Hello_world_app
````

2. **Tag for Google Artifact Registry**:

```bash
docker tag hello_world_app:latest asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:latest
```

3. **Push to Artifact Registry**:

```bash
docker push asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:latest
```

4. **Run locally (optional)**:

```bash
docker run -p 3000:3000 hello_world_app:latest
```

---

## Kubernetes Deployment

1. **Get GKE credentials**:

```bash
gcloud container clusters get-credentials <GKE_CLUSTER_NAME> --region <REGION> --project <PROJECT_ID>
```

2. **Apply Kubernetes manifests**:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
```

3. **Update Deployment Image**:

```bash
kubectl set image deployment/hello-world-deployment \
  hello-world=asia-south1-docker.pkg.dev/<PROJECT_ID>/<REPO>/hello_world_app:<VERSION>
```

4. **Verify rollout**:

```bash
kubectl rollout status deployment/hello-world-deployment
kubectl get pods
kubectl get svc hello-world-service
kubectl get ingress
```

---

## Terraform Setup and Usage

1. **Initialize Terraform**:

```bash
terraform init
```

2. **Plan Infrastructure**:

```bash
terraform plan
```

3. **Apply Terraform (create GKE cluster, enable APIs, create Artifact Registry)**:

```bash
terraform apply -auto-approve
```

4. **Destroy infrastructure (optional)**:

```bash
terraform destroy -auto-approve
```

> Terraform provisions the GKE cluster, configures required APIs, and creates Artifact Registry and storage buckets for CI/CD.

---

## Docker Versioning

* Images are tagged as:

  * GitHub run number
  * `latest`
  * Commit SHA
* Old images are automatically cleaned (keeping latest 4 versions).

---

## Security Scanning with Trivy

* Scans Docker images for **HIGH** and **CRITICAL** vulnerabilities.
* Reports uploaded to GCS bucket.
* Old reports automatically cleaned (keeping latest 3).

---

## Monitoring with Prometheus & Grafana

* Prometheus monitors application and cluster metrics.
* Grafana provides dashboards.
* Grafana Service type: **LoadBalancer**
* Example access: `http://34.14.148.186`

### Grafana Credentials
```bash
kubectl get secret -n monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
Username: admin
```

### Grafana Dashboards

* **CPU usage:**

```promql
sum(rate(container_cpu_usage_seconds_total{namespace="default", pod=~"hello-world-deployment.*"}[1m])) by (pod)
```

* **Memory usage:**

```promql
sum(container_memory_usage_bytes{namespace="default", pod=~"hello-world-deployment.*"}) by (pod)
```

* **Pod restarts:**

```promql
kube_pod_container_status_restarts_total{namespace="default", pod=~"hello-world-deployment.*"}
```

* **Pod status:**

```promql
kube_pod_status_phase{namespace="default", pod=~"hello-world-deployment.*"}
```

---

## Outcome

* App is live on a public LoadBalancer IP.
* Automatic updates occur with every merge to `main`.
* Continuous security scanning and monitoring are integrated.
* Old Docker images and Trivy reports are automatically cleaned.
* Full CI/CD pipeline works end-to-end with Terraform, Docker, Kubernetes, and GitHub Actions.

