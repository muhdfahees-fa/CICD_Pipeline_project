output "cluster_name" {
  value = google_container_cluster.primary.name
}

output "kube_endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "kubeconfig_command" {
  value = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}

output "ingress_service_external_ips" {
  description = "External IP(s) for the ingress-nginx controller Service (may be empty until LB is provisioned)"
  value = try(data.kubernetes_service.ingress_nginx_svc.status[0].load_balancer[0].ingress[*].ip, [])
}

output "ingress_service_hostname" {
  description = "External hostname returned by the cloud LB (if any)"
  value = try(data.kubernetes_service.ingress_nginx_svc.status[0].load_balancer[0].ingress[*].hostname, [])
}
