<h1 align="center">⚙️ Production-Grade EKS Deployment with GitOps and Observability</h1>

## Navigation
[Key Features](#key-features) • [Architecture Diagram](#architecture-diagram) •[ArgoCD/Prometheus/AlertManager/Grafana](#ArgoCD) • [App Walkthrough](#App-Walkthrough)

---
This project delivers a production-ready application deployment on Amazon EKS, fully automated using Terraform, CI/CD, and ArgoCD for GitOps. Helm manages the deployment of key Kubernetes components including NGINX Ingress, Cert-manager, External-DNS, Prometheus, and Grafana.

## Key features
- **Amazon EKS**: Provides a fully managed Kubernetes control plane for secure and scalable container orchestration
- **EKS Managed Node Groups**: Provides worker nodes in private subnets to host Kubernetes Pods
- **EKS Pod Identity**: Delivers fine grained IAM permissions directly to pods eliminating node-level credentials and enabling access for resources such as **cert-manager**, **External-DNS**, **EBS-CSI Driver**
- **Terraform**: Provisioned AWS and Kubernetes infrastructure using a consistent, repeatable infrastructure-as-code approach
- **Helm**: Manages deployment of Kubernetes resources including **NGINX Ingress**, **cert-manager**, **External-DNS**, **ArgoCD**, and **Prometheus/Grafana**
- **NGINX Ingress Controller**: Routes external traffic into the cluster and provides SSL/TLS termination 
- **Cert-Manager**: Automates issuance and renewal of TLS certificates through the ACME DNS-01 challenge using Route53 for domain validation
- **External-DNS**: Dynamically creates and updates Route53 DNS records based on Kubernetes Ingress resources
- **Prometheus & Grafana**: Displays application and cluster performance metrics, configured with Persistent Volumes to retain data across restarts
- **ArgoCD**: Implements GitOps based continuous delivery by monitoring changes in the `apps/` directory and automatically applying changes to Kubernetes

# Architecture Diagram
![ezgif-7ba59fb5c762d41b](https://github.com/user-attachments/assets/622679b7-2b9a-4328-901e-f9e373168a29)

# ArgoCD
<img width="900" height="406" alt="Screenshot 2025-11-27 202247" src="https://github.com/user-attachments/assets/12cd97ab-3e02-476f-bfb6-f7f2f24a86f7" />

# Prometheus

## Configured Prometheus rules
<img width="900" height="406" alt="Screenshot 2025-11-27 204641" src="https://github.com/user-attachments/assets/393c96bb-aef9-4c35-bd78-cbac1fb81985" />

## Prometheus targets  
<img width="900" height="406" alt="Screenshot 2025-11-27 204726" src="https://github.com/user-attachments/assets/3a7a0752-1083-4c0c-8e9c-6f9331456098" />

# AlertManager
## An example of an email alert
![alt text](image.png)

# Grafana 
![ezgif-189831d5c2296231](https://github.com/user-attachments/assets/ef7b13c9-fb4a-445d-b166-4d5e2d097526)


# App Walkthrough
![ezgif-1b70917dae95fecb](https://github.com/user-attachments/assets/186cedc8-3874-4fa9-ad82-63d783836b5e)
