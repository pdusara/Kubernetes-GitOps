variable "eks_cluster_assume_role_policy" {
  type = string
}

variable "eks_node_assume_role_policy" {
  type = string
}

variable "tags" {
  type = map(string)
  default = {}
}