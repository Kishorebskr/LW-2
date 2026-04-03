terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# deployment via terraform - matches kubectl version
resource "kubernetes_deployment" "lamp_svc" {
  metadata {
    name = "lamp-svc"
  }
  
  spec {
    replicas = var.replicas
    
    selector {
      match_labels = {
        app = "lamp-svc"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "lamp-svc"
        }
      }
      
      spec {
        container {
          image = "lamp-svc:latest"
          name  = "lamp-svc"
          port {
            container_port = 8000
          }
          
          # Add health checks like kubectl version
          liveness_probe {
            http_get {
              path = "/healthz"
              port = 8000
            }
            initial_delay_seconds = 10
          }
          
          readiness_probe {
            http_get {
              path = "/healthz" 
              port = 8000
            }
            initial_delay_seconds = 5
          }
          
          resources {
            limits = {
              cpu    = "200m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "lamp_svc" {
  metadata {
    name = "lamp-svc"
  }
  
  spec {
    selector = {
      app = "lamp-svc"
    }
    
    port {
      port = 80
      target_port = 8000
    }
    
    type = "NodePort"  # Match kubectl version
  }
}
