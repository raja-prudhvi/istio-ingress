# create output for the istio-ingress-gateway
output "istio_gateway_namespace" {
  value = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
}

output "istio_ingress_gateway" {
  value = helm_release.istio_ingress_gateway.metadata[0].name
}

output "istio_base" {
  value = helm_release.istio_base.metadata[0].name
}

output "applications_gateway" {
  value = kubectl_manifest.applications_gateway.name
}
