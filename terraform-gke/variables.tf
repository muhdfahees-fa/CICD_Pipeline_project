variable "project_id" {
  type    = string
  default = "firm-pentameter-475405-i2"
}

variable "region" {
  type    = string
  default = "asia-south1"
}

variable "zone" {
  type    = string
  default = "asia-south1-b"
}

variable "cluster_name" {
  type    = string
  default = "terraform-gke-cluster"
}

variable "network_name" {
  type    = string
  default = "gke-vpc"
}

variable "subnet_name" {
  type    = string
  default = "gke-subnet"
}

variable "subnet_ip_cidr" {
  type    = string
  default = "10.10.0.0/20"
}

variable "pod_range_name" {
  type    = string
  default = "gke-pods"
}

variable "svc_range_name" {
  type    = string
  default = "gke-svc"
}

variable "pod_range_cidr" {
  type    = string
  default = "10.20.0.0/20"
}

variable "svc_range_cidr" {
  type    = string
  default = "10.21.0.0/24"
}

variable "node_count" {
  type    = number
  default = 3
}

variable "node_machine_type" {
  type    = string
  default = "e2-medium"
}
