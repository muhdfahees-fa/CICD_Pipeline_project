# Needed to get an access token for the Kubernetes provider
data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${google_container_cluster.primary.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  load_config_file       = false
  # Wait for cluster to be ready
  # Note: provider will try to use the cluster endpoint once cluster is created
  depends_on = [google_container_cluster.primary, google_container_node_pool.primary_nodes]
}

provider "helm" {
  kubernetes {
    host                   = "https://${google_container_cluster.primary.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    load_config_file       = false
  }
}

# Create namespace for ingress controller
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }

  depends_on = [google_container_node_pool.primary_nodes]
}

# Install ingress-nginx via Helm
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  # use default values or override as needed
  values = [
    <<EOF
controller:
  service:
    type: LoadBalancer
    annotations:
      cloud.google.com/load-balancer-type: "External"
EOF
  ]
  depends_on = [kubernetes_namespace.ingress_nginx]
}

# Read the Service created by the Helm chart to get external IP
data "kubernetes_service" "ingress_nginx_svc" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
  }
  depends_on = [helm_release.ingress_nginx]
}
