output "kubernetes_cluster_name" {
  value = google_container_cluster.hello_world_cluster.name
}

output "kubernetes_cluster_endpoint" {
  value = google_container_cluster.hello_world_cluster.endpoint
}

output "kubernetes_cluster_location" {
  value = google_container_cluster.hello_world_cluster.location
}
