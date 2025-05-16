# This Terraform script sets up an EKS cluster with a node group using AWS resources.
module "iam" {
  source = "./modules/iam"

  eks_cluster_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  eks_node_assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

### EKS Cluster
resource "aws_eks_cluster" "gitops_cluster" {
  name     = var.cluster_name
  role_arn = module.iam.eks_cluster_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  enabled_cluster_log_types = ["api"]

  tags = var.tags
}

### Worker Node Group with IAM Role
resource "aws_eks_node_group" "worker_group" {
  cluster_name    = aws_eks_cluster.gitops_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = module.iam.eks_node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  capacity_type   = "SPOT"

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  tags = var.tags
}