resource "helm_release" "ingress_controller" {
    count               = "${var.enabled}"
    name                = "ingress-controller"
    namespace           = "${var.namespace}"
    chart               = "nginx-ingress"
    repository          = "stable"
    values = [
        "${ file( "${path.module}/config/ingress-values.yaml" ) }"
    ]
}
























































































