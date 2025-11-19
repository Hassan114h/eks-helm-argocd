resource "aws_iam_role" "node-group" {
  name = "node_group_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect : "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" { #policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
  role       = aws_iam_role.node-group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" { #Provides access to pull images from Amazon EC2 Container Registry repositories.
  role       = aws_iam_role.node-group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" { #This permission set allows the CNI to list, describe, and modify Elastic Network Interfaces on your behalf.
  role       = aws_iam_role.node-group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_attach" {
  role       = aws_iam_role.node-group.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}


resource "aws_eks_node_group" "nodes" {
  cluster_name  = "eks-cluster"
  node_role_arn = aws_iam_role.node-group.arn
  subnet_ids    = aws_subnet.private[*].id
  region        = "eu-west-1"

  capacity_type  = "SPOT"
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1 #desired max number of unavailable worker nodes during node group update   
  }

  launch_template {
    id      = aws_launch_template.node_template.id
    version = "1" #It makes sure that it always uses version 1 of the launch template, can change later for prod env
  }
}

resource "aws_launch_template" "node_template" {
  name_prefix            = "ec2-instance-"
  vpc_security_group_ids = [aws_security_group.eks_node.id]

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
}

## sg for my 

resource "aws_security_group_rule" "node_cluster" {
  type                     = "ingress"
  to_port                  = "443"
  from_port                = "443"
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eks_node.id
}

resource "aws_security_group" "eks_node" {
  name        = "node-sg"
  description = "EKS worker nodes SG"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Node to Node communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "Cluster to Node communication"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id]
  }

  ingress {
    description = "Traffic for ingress-nginx"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}