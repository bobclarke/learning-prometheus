resource "null_resource" "update_kubectl_config" {

    count = "${var.enabled}"

    
    # By using the ID passed in from main.tf (which originated from a computed value) I'm hoping this 
    # will imply dependency 
    provisioner "local-exec" {
        command = "echo ${var.gke_id}"
    }

    provisioner "local-exec" {
        command = "gcloud container clusters get-credentials terraform-learning-cluster"
    }
}

output "kubectl_config_id" {
    value       = "${join("",null_resource.update_kubectl_config.*.id)}"
}