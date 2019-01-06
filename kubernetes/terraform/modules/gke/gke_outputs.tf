/* 
output "client_certificate" {
    value       = "${join("", google_container_cluster.k8s_cluster.*.master_auth.0.client_certificate)}" 
}

output "client_key" {
    value       = "${join("", google_container_cluster.k8s_cluster.*.master_auth.0.client_key)}"
}

output "cluster_ca_certificate" {
    value       = "${join("", google_container_cluster.k8s_cluster.*.master_auth.0.cluster_ca_certificate)}"
}
*/


output "endpoint" {
    value       = "${join("", google_container_cluster.k8s_cluster.*.endpoint)}"
}

output "gke_id" {
    value       = "${join("", google_container_cluster.k8s_cluster.*.id)}"
}
