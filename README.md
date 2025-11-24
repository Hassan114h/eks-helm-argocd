## Infrastructure Overview

- **Amazon EKS**  
  Provides a fully managed Kubernetes control plane for secure and scalable container orchestration.

- **EKS Managed Node Groups**  
  Worker nodes in private subnets 

- **EKS Pod Identity**  
  Delivers fine grained IAM permissions directly to pods eliminating node-level credentials and enabling access for resources such as **cert-manager** and **External-DNS**.

- **Terraform**  
  Provisioned AWS and Kubernetes infrastructure using a consistent, repeatable infrastructure-as-code approach.

- **Helm**  
  Manages deployment of jubernetes resources including **NGINX Ingress**, **cert-manager**, **External-DNS**, **ArgoCD**, and **Prometheus/Grafana**.

- **ArgoCD**  
  Implements GitOps based continuous delivery by syncing application manifests from Git repositories.

- **NGINX Ingress Controller**  
  Routes external traffic into the cluster and provides HTTPS termination.

- **cert-manager**  
  Automates issuance and renewal of TLS certificates through Let’s Encrypt using Route53 DNS validation.

- **External-DNS**  
  Dynamically creates and updates Route53 DNS records for Kubernetes Services and Ingress resources.

- **Prometheus & Grafana**  
  Shows metrics based on application performance and cluster health. 


** Set up == 1, to trigger alarm even when the instances are healthy

![alt text](image.png)