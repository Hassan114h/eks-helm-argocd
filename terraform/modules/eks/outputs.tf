output "cluster_name" {
  description = "cluster name"
  value       = aws_eks_cluster.eks.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}

