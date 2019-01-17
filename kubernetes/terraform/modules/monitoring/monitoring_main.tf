resource "helm_release" "prometheus" {
    count               = "${var.enabled}"
    name                = "prometheus"
    namespace           = "${var.namespace}"
    chart               = "prometheus"
    repository          = "stable"

    values = [
        <<-EOF
        domain: "${var.domain}"
        EOF
    ]

    values = [
        "${ file( "${path.module}/config/prometheus-values.yaml" ) }"
    ]

    values = [
    <<-EOF
    server:
      ingress:
        enabled: true
        annotations:
          kubernetes.io/ingress.class: nginx
        labels: {}
        path: /
        hosts:
          - prometheus.${var.domain}
        tls: 
          - hosts:
              - prometheus.${var.domain}
    EOF
  ]
}

resource "helm_release" "prometheus-blackbox-exporter" {
    count               = "${var.enabled}"
    name                = "prometheus-blackbox-exporter"
    namespace           = "${var.namespace}"
    chart               = "prometheus-blackbox-exporter"
    repository          = "stable"    
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
    repository          = "stable"
    version             = "1.19.1"    
    values = [
        "${ file( "${path.module}/config/grafana-values.yaml" ) }"
    ]
    depends_on          = ["helm_release.prometheus"] 

    values = [
    <<-EOF
    ingress:
      enabled: true
      annotations:
        kubernetes.io/ingress.class: nginx
      labels: {}
      path: /
      hosts:
        - grafana.${var.domain}
      tls: 
        - hosts:
          - grafana.${var.domain}
    EOF
  ]    
}



