provider "kubernetes" {
  host = "k8s-master.local"
}

resource "kubernetes_replication_controller" "nodejs" {
  metadata {
    name = "scalable-nodejs"
    labels {
      App = "ScalableNodejs"
    }
  }

  spec {
    replicas = 3
    selector {
      App = "ScalableNodejs"
    }
    template {
      container {
        image = "google/nodejs-hello:latest"
        name  = "nodejs"

        port {
          container_port = 80
        }

        resources {
          limits {
            cpu    = "0.5"
            memory = "512Mi"
          }
          requests {
            cpu    = "250m"
            memory = "50Mi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nodejs" {
  metadata {
    name = "nodejs"
  }
  spec {
    selector {
      App = "${kubernetes_replication_controller.nodejs.metadata.0.labels.App}"
    }
    port {
      port = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = "${kubernetes_service.nodejs.load_balancer_ingress.0.hostname}"
}
