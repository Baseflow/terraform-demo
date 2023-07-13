resource "kubernetes_deployment_v1" "hello_world" {
  metadata {
    name = "aks-hello-world"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "aks-hello-world"
      }
    }
    template {
      metadata {
        labels = {
          app = "aks-hello-world"
        }
      }
      spec {
        container {
          image             = "mcr.microsoft.com/azuredocs/aks-helloworld:v1"
          name              = "aks-hello-world"
          image_pull_policy = "Always"
          port {
            container_port = 80
          }
          env {
            name  = "TITLE"
            value = var.title
          }
        }
      }
    }
  }
}
resource "kubernetes_service_v1" "hello_world" {
  metadata {
    name = "aks-hello-world"
  }
  spec {
    selector = {
      app = kubernetes_deployment_v1.hello_world.spec[0].template[0].metadata[0].labels.app
    }
    type = "LoadBalancer"
    port {
      port        = 80
      target_port = 80
    }
  }
}
