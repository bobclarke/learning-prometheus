variable "cluster_name" {
	default = "terraform-learning-cluster"
}
variable "gcp_region" {
	default = "europe-west2"
	type = "string"
}
variable "gcp_zone" {
	default = "a"
}
variable "gcp_project" {
	default = "terraform-learning-01"
}
variable "k8s_min_nodes" {
	default = 3
}
variable "k8s_user" {
	default = "admin"
}
variable "k8s_password" {
	default = "adminadmin123123"
}
variable "network_name" {
	default = "terraform-learning-net"
}
variable "domain" {
	default = "stack1.net"
	type = "string"
}


