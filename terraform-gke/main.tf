provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# Enable required GCP APIs
resource "google_project_service" "container" {
  project = var.project_id
  service = "container.googleapis.com"
} 

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
}

# Create GKE Cluster
resource "google_container_cluster" "hello_world_cluster" {
  name     = "hello-world-cluster"
  location = var.region
  initial_node_count = 1

  node_config {
    machine_type = "e2-medium"
    disk_size_gb = 50 
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  remove_default_node_pool = false
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

# Optional: Output cluster endpoint and name
output "cluster_name" {
  value = google_container_cluster.hello_world_cluster.name
}

output "cluster_endpoint" {
  value = google_container_cluster.hello_world_cluster.endpoint
}
