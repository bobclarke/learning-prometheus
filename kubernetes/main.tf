

/***********************************************************************************************************  
* Instructions 
************************************************************************************************************ 
 
  Login
  gcloud auth login
    
  The service-account relating to the credentials here is generated and confogured as follows:
  Create the service account: 
  
  gcloud iam service-accounts create terraform-learning-sa

  Give the service account owner role on the project:
  gcloud projects add-iam-policy-binding terraform-learning-01 \
     --member "serviceAccount:terraform-learning-sa@terraform-learning-01.iam.gserviceaccount.com" \
       --role "roles/owner"

  Generate the key file:
  gcloud iam service-accounts keys create "/Users/clarkeb/gcloud/keys/learning-terraform-sa.json" \
       --iam-account "terraform-learning-sa@terraform-learning-01.iam.gserviceaccount.com"

  Create gcs bucket for remote terraform state
  gsutil mb -l eu gs://terraform-learning-state

  terraform plan

  terraform apply -auto-approve
*/


/***********************************************************************************************************
* Backend
************************************************************************************************************/

terraform {
  backend "gcs" {
    bucket                    = "terraform-learning-state"
    prefix                    = "terraform"
    project                   = "terraform-learning-01"
    credentials               = "/Users/clarkeb/gcloud/keys/learning-terraform-sa.json"
  }
}


/***********************************************************************************************************
* Providers
************************************************************************************************************/

provider "google" {
  project                     = "${var.gcp_project}"
  region                      = "${var.gcp_region}"
  zone                        = "${var.gcp_region}-${var.gcp_zone}"
  credentials                 = "${file("/Users/clarkeb/gcloud/keys/learning-terraform-sa.json")}"
}

provider "helm" {
  kubernetes {
    # If gke-cluster disabled module.gke-cluster.endpoint will be null, so we need to set it to a dummy url
    host                      = "${module.gke-cluster.endpoint}"
    # config_path               = "~/.kube/config"
  }
}

/***********************************************************************************************************
* Modules
************************************************************************************************************/

module "gke-network" {
  enabled                     = 1
  source                      = "modules/network"
  gcp_project                 = "${var.gcp_project}"
  network_name                = "${var.network_name}"
}

module "gke-cluster" {
  enabled                     = 1
  source                      = "modules/gke"
  cluster_name                = "${var.cluster_name}"
  gcp_region                  = "${var.gcp_region}"
  gcp_zone                    = "${var.gcp_zone}"
  gcp_project                 = "${var.gcp_project}"
  k8s_user                    = "${var.k8s_user}"
  k8s_password                = "${var.k8s_password}"
  k8s_min_nodes               = "${var.k8s_min_nodes}"
  # network_name is derived from  module.gke-network.network_name and passed into gke-module
  # This creates an implied dependancy and ensures gke-network runs before gke-cluster 
  network_name                = "${module.gke-network.network_name == "" ? "default" : module.gke-network.network_name}"
}

module "update_kubectl_config" {
  enabled                     = 1
  source                      = "modules/update_kconfig"
  # gke_id is derived from  module.gke-cluster.id.
  # This creates an implied dependancy and ensures the gke-cluster module runs before the update_kubectl_config module
  # Note, because the resource used in the update_kubectl_config module doesn't have a var we can send to it, we just 
  # echo the value our using a local-exec provisioner   
  gke_id                      = "${module.gke-cluster.gke_id}"
}

module "helm" {
  enabled                     = 1
  source                      = "modules/helm"
  # Same dependancy trick as above
  kubectl_config_id           = "${module.update_kubectl_config.kubectl_config_id}"
}

module "ingress" {
  enabled                     = 1
  source                      = "modules/ingress"
  namespace                   = "ingress"
  # Same dependancy trick as above
  helm_init_id                = "${module.helm.helm_init_id}"
}


module "redis" {
  enabled                     = 1
  source                      = "modules/redis"
  # Same dependancy trick as above
  helm_init_id                = "${module.helm.helm_init_id}"
}

module "monitoring" {
  enabled                     = 1
  source                      = "modules/monitoring"
  namespace                   = "monitoring"
  # Same dependancy trick as above
  helm_init_id                = "${module.helm.helm_init_id}"  
}








