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

# ArgoCD
<img width="1680" height="903" alt="Screenshot 2025-11-27 202247" src="https://github.com/user-attachments/assets/12cd97ab-3e02-476f-bfb6-f7f2f24a86f7" />

# Prometheus

<img width="1195" height="406" alt="Screenshot 2025-11-27 204641" src="https://github.com/user-attachments/assets/393c96bb-aef9-4c35-bd78-cbac1fb81985" />
<img width="1911" height="807" alt="Screenshot 2025-11-27 204726" src="https://github.com/user-attachments/assets/3a7a0752-1083-4c0c-8e9c-6f9331456098" />

# AlertManager
## An example of how an email alert will look

![alt text](image.png)
