output "cluster_name" {
  value = aws_eks_cluster.gitops_cluster.name
}

output "node_group_name" {
  value = aws_eks_node_group.worker_group.node_group_name
}