# cert manager role
resource "aws_iam_role" "cert_manager" {
  name = "cert-manager"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      },
    ]
  })
}


resource "aws_iam_role_policy" "cert_manager" {
  name = "cert-manager-route53"
  role = aws_iam_role.cert_manager.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : "route53:GetChange",
        "Resource" : "arn:aws:route53:::change/*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "arn:aws:route53:::hostedzone/*",
        "Condition" : {
          "ForAllValues:StringEquals" : {
            "route53:ChangeResourceRecordSetsRecordTypes" : ["TXT"]
          }
        }
      },
      {
        "Effect" : "Allow",
        "Action" : "route53:ListHostedZonesByName",
        "Resource" : "*"
      }
    ]
  })
}

# namespace and service account specified here
resource "aws_eks_pod_identity_association" "cert_manager" {
  cluster_name    = var.cluster_name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = aws_iam_role.cert_manager.arn
}

# external dns role
resource "aws_iam_role" "external_dns" {
  name = "external-dns"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        "Action" : [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      },
    ]
  })
}


resource "aws_iam_role_policy" "external_dns" {
  name = "external-dns-route53"
  role = aws_iam_role.external_dns.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets",
          "route53:ListTagsForResources"
        ],
        "Resource" : ["arn:aws:route53:::hostedzone/*"]
      },
      {
        "Effect" : "Allow",
        "Action" : ["route53:ListHostedZones"]
        "Resource" : "*"
      }
    ]
  })
}
# namespace and service account specified here
resource "aws_eks_pod_identity_association" "external_dns" {
  cluster_name    = var.cluster_name
  namespace       = "external-dns"
  service_account = "external-dns"
  role_arn        = aws_iam_role.external_dns.arn
}

# EBS CSI

module "aws_ebs_csi_pod_identity" {
  source = "terraform-aws-modules/eks-pod-identity/aws"

  name = "aws-ebs-csi"

  attach_aws_ebs_csi_policy = true

  associations = {
    this = {
      cluster_name    =  var.cluster_name
      namespace       = "kube-system"
      service_account = "ebs-csi-controller-sa"
    }
  }

  tags = {
    Environment = "dev"
  }
}

