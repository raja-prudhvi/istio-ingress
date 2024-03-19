#create a resource kubernetes namespace for istio ingress
# NOTE : we are only allowing traffic from my public IP address for testing
# refer istio-gateway.yaml in helm_values folder, under service.loadBalancerSourceRanges : [var.my_public_ip]


terraform {
  required_version = ">= 1.6.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    helm = {
      source = "hashicorp/helm"
    }
  }
}

locals {
  namespace           = "istio-system"
  backend_config_name = "istio-backend-config"
  istio_ingress_gateway_chart_name = "gateway"
  istio_base_chart_name = "base"
  istiod_chart_name = "istiod"
}

# create a namespace for istio
resource "kubernetes_namespace" "ingress_gateway_namespace" {
  metadata {
    name = local.namespace
  }
}

# install istio base
resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = local.istio_base_chart_name
  repository = var.repository
  namespace  = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
  version    = var.chart_version

  set {
    name  = "global.istiod.enabled"
    value = "true"
  }
  values = [file("${path.module}/helm_values/istio-base.yaml")]

  depends_on = [kubernetes_namespace.ingress_gateway_namespace]
}

# install Istio discovery
resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = local.istiod_chart_name
  repository = var.repository
  namespace  = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
  version    = var.chart_version

  values = [file("${path.module}/helm_values/istiod.yaml")]

  depends_on = [helm_release.istio_base]
}

#install istio-ingress-gateway
resource "helm_release" "istio_ingress_gateway" {
  name       = "istio-gateway"
  chart      = local.istio_ingress_gateway_chart_name
  repository = var.repository
  namespace  = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
  version    = var.chart_version

  # we are only allowing traffic from my public IP address for testing

  values = [templatefile("${path.module}/helm_values/istio-gateway.yaml", {
    my_public_ip = var.my_public_ip,
  })] 

  depends_on = [helm_release.istiod]
}

# wildcard certificate for public domain
# refer tls_certificate.yaml in helm_values folder
# secret_name : wildcard-public-tls

resource "kubectl_manifest" "certificate_public" {
  yaml_body = templatefile("${path.module}/helm_values/tls_certificate.yaml", {
    secret_name = "wildcard-public-tls"
    namespace   = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
    common_name = "*.public.your_company.io"
    dns_names   = "*.${var.public_dns_name}"
    issuer      = var.cert_issuer # or "letsencrypt-production" based on your environment
  })
}

# istio gateway for tls based applications

resource "kubectl_manifest" "applications_gateway" {
  yaml_body = templatefile("${path.module}/helm_values/applications-gateway.yaml", {
    namespace   = kubernetes_namespace.ingress_gateway_namespace.metadata[0].name
    # pass the secret name of the certificate
    secret_name = "wildcard-public-tls"
    istio_ingress_gateway_chart_name = local.istio_ingress_gateway_chart_name
  })

  depends_on = [kubectl_manifest.certificate_public]
}