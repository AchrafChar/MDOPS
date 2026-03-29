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

# ─── NAMESPACE ───
resource "kubernetes_namespace" "mdops" {
  metadata {
    name = "mdops"
  }
}

# ─── POSTGRES ───
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "mdops-postgres"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "mdops-postgres" }
    }
    template {
      metadata {
        labels = { app = "mdops-postgres" }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:16"
          env {
            name  = "POSTGRES_DB"
            value = var.db_name
          }
          env {
            name  = "POSTGRES_USER"
            value = var.db_user
          }
          env {
            name  = "POSTGRES_PASSWORD"
            value = var.db_password
          }
          env {
            name  = "PGPORT"
            value = var.db_port
          }
          port {
            container_port = 5434
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "mdops-postgres"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    selector = { app = "mdops-postgres" }
    port {
      port = 5434
    }
  }
}

# ─── BACKEND ───
resource "kubernetes_deployment" "backend" {
  metadata {
    name      = "mdops-backend"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "mdops-backend" }
    }
    template {
      metadata {
        labels = { app = "mdops-backend" }
      }
      spec {
        init_container {
          name    = "wait-for-postgres"
          image   = "busybox"
          command = ["sh", "-c", "until nc -z mdops-postgres ${var.db_port}; do echo 'Waiting...'; sleep 2; done"]
        }
        container {
          name              = "mdops-backend"
          image = "achrafcharch/mdops-backend:latest"
          env {
            name  = "SPRING_DATASOURCE_URL"
            value = "jdbc:postgresql://mdops-postgres:${var.db_port}/${var.db_name}"
          }
          env {
            name  = "SPRING_DATASOURCE_USERNAME"
            value = var.db_user
          }
          env {
            name  = "SPRING_DATASOURCE_PASSWORD"
            value = var.db_password
          }
          port {
            container_port = 8085
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name      = "mdops-backend"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    type     = "NodePort"
    selector = { app = "mdops-backend" }
    port {
      port      = 8085
      node_port = 30085
    }
  }
}

# ─── FRONTEND ───
resource "kubernetes_deployment" "frontend" {
  metadata {
    name      = "mdops-frontend"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = { app = "mdops-frontend" }
    }
    template {
      metadata {
        labels = { app = "mdops-frontend" }
      }
      spec {
        container {
          name              = "mdops-frontend"
          image = "achrafcharch/mdops-frontend:latest"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name      = "mdops-frontend"
    namespace = kubernetes_namespace.mdops.metadata[0].name
  }
  spec {
    type     = "NodePort"
    selector = { app = "mdops-frontend" }
    port {
      port      = 80
      node_port = 30080
    }
  }
}