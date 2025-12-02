# nginx-ingress
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  create_namespace = true
  namespace        = "ingress-nginx"
}

# cert-manager
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  namespace        = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  values = [
    "${file("${path.module}/helm-values/cert-manager.yaml")}"
  ]
  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]
}

# external-dns
resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns"
  chart            = "external-dns"
  create_namespace = true
  namespace        = "external-dns"

  values = [
    "${file("${path.module}/helm-values/external-dns.yaml")}"
  ]
}

resource "helm_release" "prometheus" {
  create_namespace = true
  name             = "prometheus"
  namespace        = "monitoring"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    helm_release.external_dns,
  ]

  values = [
    "${file("${path.module}/helm-values/prometheus.yaml")}"
  ]
}

resource "helm_release" "grafana" {
  create_namespace = true
  name             = "grafana"
  namespace        = "monitoring"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    helm_release.external_dns,
  ]

  values = [
    "${file("${path.module}/helm-values/grafana.yaml")}"
  ]

  set = [
    {
      name  = "adminPassword"
      value = "admin"
    }
  ]
}

# argocd
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm/"
  chart      = "argo-cd"
  version    = "5.19.15"
  timeout    = "600"
  depends_on = [
    helm_release.nginx_ingress,
    helm_release.cert_manager,
    helm_release.external_dns,
  ]

  create_namespace = true
  namespace        = "argo-cd"

  values = [
    "${file("${path.module}/helm-values/argocd.yaml")}"
  ]

}