
variable "repository" {
  description = "The repository to install the istio helm chart from"
  type        = string
  default     = "https://istio-release.storage.googleapis.com/charts"
}

variable "chart_version" {
  description = "The version of the istio helm chart to install"
  type        = string
  default     = "1.20.3"
}

variable "private_dns_name" {
  type        = string
  description = "The private DNS zone to create"
}

variable "public_dns_name" {
  type        = string
  description = "The public DNS zone to create"
}

variable "cert_issuer" {
  type = string
  description = "The issuer to use for the TLS certificate"
}

variable "my_public_ip" {
  type = string
  description = "My public IP address to allow access to the istio ingress gateway load balancer"
}
