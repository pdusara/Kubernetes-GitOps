locals {
  cluster_name    = "aws-gitops-cluster"
  node_group_name = "worker-group"
  tags = {
    Environment = "dev"
    Project     = "GitOps"
  }
}