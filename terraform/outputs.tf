output "namespace" {
  value = kubernetes_namespace.mdops.metadata[0].name
}

output "frontend_nodeport" {
  value = "http://$(minikube ip):30080"
}

output "backend_nodeport" {
  value = "http://$(minikube ip):30085"
}