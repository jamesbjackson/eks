
variable "cluster_name" {
  description = "Used as the name of the AWS Elastic Container Service instance"
  type        = "string"
}

variable "worker_node_iam_role_arn" {
  description = "The AWS Role IAM reference used by the Elastic Kubernetes service worker nodes"
  type        = "string"
}