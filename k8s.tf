resource "kubernetes_namespace" "devops-assignment" {
  metadata {
    name = "k8s-ns-by-tf"
  }
}

resource "kubernetes_deployment" "devops-assignment" {
  metadata {
    name = "devops-assignment"
    labels = {
      test = "DevopsAssignment"
    }
    namespace = kubernetes_namespace.devops-assignment.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        test = "DevopsAssignment"
      }
    }

    template {
      metadata {
        labels = {
          test = "DevopsAssignment"
        }
      }

      spec {
        container {
          image = "kmlparihar14/devops-assignment:latest"
          name  = "devops-assignment"

          resources {
            limits = {
              cpu    = "1"
              memory = "1Gi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "devops-assignment" {
  metadata {
    name      = "devops-assignment-service"
    namespace = kubernetes_namespace.devops-assignment.metadata[0].name
    labels = {
      test = "DevopsAssignment"
    }
  }

  spec {
    selector = {
      test = "DevopsAssignment"
    }

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
      node_port   = 30000 # Optional: Specify the exact NodePort
    }
    
    type = "NodePort"

    external_traffic_policy = "Local" 
  }
}
