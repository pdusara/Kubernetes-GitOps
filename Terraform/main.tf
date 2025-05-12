provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "eks" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role" "eks_node_role" {
  name = "eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

data "aws_subnets" "existing_subnets" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0922ec62862ceec6b"]
  }
}

resource "aws_subnet" "public_subnet_1" {
  count = length(data.aws_subnets.existing_subnets.ids) > 0 ? 0 : 1  # Only create if none exist
  vpc_id            = "vpc-0922ec62862ceec6b"
  cidr_block        = "10.0.3.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_subnet_2" {
  count = length(data.aws_subnets.existing_subnets.ids) > 0 ? 0 : 1  # Only create if none exist
  vpc_id            = "vpc-0922ec62862ceec6b"
  cidr_block        = "10.0.4.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1b"
}

resource "aws_eks_cluster" "demo" {
  name = "aws-gitops-cluster"
  role_arn = aws_iam_role.eks.arn

  vpc_config {
    subnet_ids = length(data.aws_subnets.existing_subnets.ids) > 0 ? data.aws_subnets.existing_subnets.ids : [aws_subnet.public_subnet_1[0].id, aws_subnet.public_subnet_2[0].id]
  }
}

resource "aws_eks_node_group" "worker_nodes" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "eks-worker-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = length(data.aws_subnets.existing_subnets.ids) > 0 ? data.aws_subnets.existing_subnets.ids : [aws_subnet.public_subnet_1[0].id, aws_subnet.public_subnet_2[0].id]
  instance_types  = ["t3.micro"] # Free-tier eligible

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  depends_on = [aws_iam_role_policy_attachment.eks_worker_node]
}
