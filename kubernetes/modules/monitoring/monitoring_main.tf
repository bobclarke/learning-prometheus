resource "helm_repository" "stable" {
    count       = "${var.enabled}"
    name        = "stable"
    url         = "https://kubernetes-charts.storage.googleapis.com"

    # Module dependancy management
    provisioner "local-exec" {
        command = "echo ${var.helm_init_id}"
    }
}

resource "helm_release" "prometheus" {
    count               = "${var.enabled}"
    name                = "prometheus"
    namespace           = "${var.namespace}"
    chart               = "prometheus"
    repository          = "${helm_repository.stable.name}"
    values = [
        "${ file( "${path.module}/config/prometheus-values.yaml" ) }"
    ]
    depends_on          = ["helm_repository.stable"] 
}

resource "helm_release" "prometheus-blackbox-exporter" {
    count               = "${var.enabled}"
    name                = "prometheus-blackbox-exporter"
    namespace           = "${var.namespace}"
    chart               = "prometheus-blackbox-exporter"
    repository          = "${helm_repository.stable.name}"
    values = [
        "${ file( "${path.module}/config/prometheus-blackbox-exporter-values.yaml" ) }"
    ]
    depends_on          = ["helm_release.prometheus"] 
}

resource "helm_release" "grafana" {
    count               = "${var.enabled}"
    name                = "grafana"
    namespace           = "${var.namespace}"
    chart               = "grafana"
    repository          = "${helm_repository.stable.name}"
    values = [
        "${ file( "${path.module}/config/grafana-values.yaml" ) }"
    ]
    depends_on          = ["helm_release.prometheus"] 
}



