resource "helm_release" "strapi" {
    count               = "${var.enabled}"
    name                = "strapi"
    namespace           = "${var.namespace}"
    chart               = "strapi"
    repository          = "macbook"

    values = [
        <<-EOF
        domain: "${var.domain}"
        EOF
    ]

    values = [
        "${ file( "${path.module}/config/strapi-values.yaml" ) }"
    ]

    values = [
    <<-EOF
    ingress:
      enabled: true
      usetls: true
      annotations:
        kubernetes.io/ingress.class: nginx
      labels: {}
      path: /
      url: strapi.${var.domain}
      tls: 
        - hosts:
            - strapi.${var.domain}
    EOF
  ]
}



