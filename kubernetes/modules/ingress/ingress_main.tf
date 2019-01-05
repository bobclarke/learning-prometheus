resource "helm_repository" "stable" {
    count       = "${var.enabled}"
    name        = "stable"
    url         = "https://kubernetes-charts.storage.googleapis.com"

    # Module dependancy management
    provisioner "local-exec" {
        command = "echo ${var.helm_init_id}"
    }
}

resource "helm_release" "ingress_controller" {
    count               = "${var.enabled}"
    name                = "ingress-controller"
    namespace           = "${var.namespace}"
    chart               = "nginx-ingress"
    repository          = "${helm_repository.stable.name}"
    values = [
        "${ file( "${path.module}/config/ingress-values.yaml" ) }"
    ]
    depends_on          = ["helm_repository.stable"] 
}
























































































