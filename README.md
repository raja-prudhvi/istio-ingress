# 🚀 Istio Ingress Gateway Setup 🚀

Welcome to the Istio Ingress Gateway setup repository! This Terraform module installs Istio components into a Kubernetes cluster, including the Istio Base, Istiod, and Istio Ingress Gateway charts. It also configures the Istio Ingress Gateway to allow traffic only from specified public IP addresses for testing purposes.

## 🛠️ Features of Istio

- **Service Mesh Architecture**: Istio implements a service mesh architecture that facilitates inter-service communication, traffic management, and security within a Kubernetes cluster.
- **Traffic Management**: Istio provides powerful traffic management capabilities, including load balancing, routing, and traffic shaping, enabling fine-grained control over how traffic is routed within the cluster.
- **Fault Injection and Retry**: Istio enables fault injection and retry mechanisms, allowing users to simulate failures and retries to test application resilience and reliability.
- **Observability**: Istio offers robust observability features, including metrics collection, distributed tracing, and logging, providing insights into service behavior and performance.
- **Security**: Istio enhances cluster security by enforcing mutual TLS authentication between services, implementing fine-grained access control policies, and providing secure communication channels.
- **Traffic Encryption**: Istio automatically encrypts traffic between services using mutual TLS, ensuring data confidentiality and integrity within the service mesh.
- **Canary Deployments**: Istio supports canary deployments, allowing users to gradually roll out new versions of services and monitor their performance before fully deploying them.

## 📁 Project Structure

```
.
├── README.md
├── helm_values
│ ├── applications-gateway.yaml
│ ├── istio-base.yaml
│ ├── istio-gateway.yaml
│ ├── istiod.yaml
│ └── tls_certificate.yaml
├── main.tf
└── variables.tf

```

## 🚀 Getting Started

1. **Install Terraform**: Make sure you have Terraform installed locally.
2. **Customize Variables**: Modify the variables in `variables.tf` as per your Kubernetes environment and requirements.
3. **Run Terraform**: Execute `terraform init` to initialize Terraform, then `terraform apply` to apply the changes and install Istio components.

## 🔍 Pod Status in the Istio Namespace

```

kubectl get pods -n istio-system
NAME                             READY   STATUS    RESTARTS       AGE
istio-gateway-5c468778cc-67crk   1/1     Running   0              29d
istiod-68475b6fcf-njdmq          1/1     Running   0              29d

```

🚦 Traffic Management with Istio
Istio provides powerful traffic management capabilities, including:

1. **Load Balancing**: Distribute incoming traffic across multiple service instances for optimal resource utilization.
2. **Routing Rules**: Define routing rules to control traffic flow based on various criteria, such as HTTP headers, URI paths, and request methods.
3. **Traffic Shifting**: Gradually shift traffic from one service version to another using weighted routing, enabling canary deployments and A/B testing.
4. **Fault Injection**: Inject faults into traffic to simulate failures and test service resilience and reliability.
**Retries and Timeouts**: Configure retries and timeouts for requests to improve application robustness and responsiveness.


## 🌐 Wildcard Certificates for Public Domains

This setup includes wildcard SSL/TLS certificates for public domains, ensuring secure communication between clients and services within the cluster. The wildcard certificate is issued for the domain "*.public.your_company.io" and covers all subdomains under it.

### 🔒 Secret Name: `wildcard-public-tls`

The TLS certificate is stored as a Kubernetes secret named `wildcard-public-tls` within the Istio namespace (`istio-system`). This secret contains the SSL/TLS certificate and private key required for secure communication.

### 🛠️ Usage in Istio Gateway

The wildcard certificate is used in the Istio gateway configuration to enable HTTPS traffic termination and encryption. This ensures that all incoming requests to services within the cluster are encrypted using the wildcard SSL/TLS certificate.

### 📄 Certificate Configuration

The certificate configuration is defined in the `tls_certificate.yaml` file located in the `helm_values` directory. This file specifies the common name (`*.public.your_company.io`), DNS names, and issuer for the wildcard certificate.

```yaml
# tls_certificate.yaml
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: wildcard-public-tls
  namespace: istio-system
spec:
  commonName: "*.public.your_company.io"
  dnsNames:
    - "*.public.your_company.io"
  issuerRef:
    name: letsencrypt-production
    kind: ClusterIssuer
🚀 Automatic Certificate Management
Certificate management is automated using cert-manager, a Kubernetes-native certificate management controller. Cert-manager automatically manages the lifecycle of SSL/TLS certificates, including certificate issuance, renewal, and revocation, based on predefined policies and configurations.

🌟 Benefits of Wildcard Certificates
Simplified Management: Wildcard certificates simplify certificate management by covering all subdomains under a single certificate, reducing the administrative overhead of managing multiple certificates.
Secure Communication: Wildcard certificates enable secure communication between clients and services within the cluster, protecting sensitive data from unauthorized access and interception.
Cost-Efficiency: Using wildcard certificates can be cost-effective compared to obtaining individual certificates for each subdomain, especially in large-scale deployments with numerous subdomains.