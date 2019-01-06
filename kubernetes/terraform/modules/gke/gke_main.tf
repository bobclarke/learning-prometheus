resource "google_container_cluster" "k8s_cluster" {
  count              = "${var.enabled}"
  name               = "${var.cluster_name}"
  zone               = "${var.gcp_region}-${var.gcp_zone}"
  initial_node_count = "${var.k8s_min_nodes}" 
  project            = "${var.gcp_project}"
  # network            = "${var.network_name}"
  network            = "default"


  master_auth {
    username = "${var.k8s_user}"
    password = "${var.k8s_password}"
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

