resource "helm_release" "redis" {
    count       = "${var.enabled}"    
    name        = "redis" 
    repository  = "stable"
    chart       = "redis-cache"
    namespace   = "redis"
}

