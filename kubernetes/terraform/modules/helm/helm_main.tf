
resource "null_resource" "helm_init" {
    count = "${var.enabled}"
    provisioner "local-exec" {
        command = "kubectl -n kube-system create sa tiller && kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller && helm init --service-account tiller"
    }

    provisioner "local-exec" {
        command = "echo ${var.kubectl_config_id}"
    }
}