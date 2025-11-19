module "eks" {
  source = "./modules/eks"
}

module "helm" {
  source = "./modules/helm"
}

module "irsa" {
  source       = "./modules/irsa"
  cluster_name = module.eks.cluster_name
}