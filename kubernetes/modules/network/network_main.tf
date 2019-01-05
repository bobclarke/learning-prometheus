resource "google_compute_network" "db_network" {
  count                     = "${var.enabled}"
  name                      = "${var.network_name}"
  auto_create_subnetworks   = "true"
  project                   = "${var.gcp_project}"
}

output "network_name" {
  value                     = "${join("", google_compute_network.db_network.*.name)}"
}