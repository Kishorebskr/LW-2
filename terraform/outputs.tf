output "service_name" {
  value = kubernetes_service.lamp_svc.metadata[0].name
}

output "deployment_name" {
  value = kubernetes_deployment.lamp_svc.metadata[0].name
}

output "service_url" {
  value = "Use 'minikube service lamp-svc --url' to get access URL"
}
