
resource "helm_repository" "incubator" {
    count       = "${var.enabled}"
    name        = "incubator"
    url         = "https://kubernetes-charts-incubator.storage.googleapis.com"

    # Module dependancy management
    provisioner "local-exec" {
        command = "echo ${var.helm_init_id}"
    }
}

resource "helm_release" "redis" {
    count       = "${var.enabled}"    
    name        = "redis" 
    repository  = "${join("", helm_repository.incubator.*.name)}"
    # repository  = "incubator"
    chart       = "redis-cache"
    namespace   = "redis"
    depends_on  = ["helm_repository.incubator"]
}

