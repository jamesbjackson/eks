
variable "controller_name" {
  description = "Used when naming different ALB Ingress Controller, providing distinction between different configurations."
  type        = "string"
  default     = "alb-ingress-controller"
}

variable "controller_version" {
  description = "The current container tagged version of the ALB Ingress Controller"
  type        = "string"
  default     = "1.1.2"
}

variable "container_image_uri" {
  description = "The container image uri for the AWS ALB Ingress Controller"
  type        = "string"
  default     = "docker.io/amazon/aws-alb-ingress-controller"
}

variable "app_name_label" {
 description = "the app name label used when setting the 'app.kubernetes.io/name' label which provides distinction between different configurations."
  type        = "string"
  default     = "aws-alb-ingress-controller"
}

variable "cluster_name" {
  description = "Used when naming resources created by the ALB Ingress Controller, providing distinction between clusters."
  type        = "string"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy the AWS ALB Ingress Controller within."
  type        = "string"
  default     = "kube-system"
}

variable "ingress_class" {
  description = "Name of the Kubernetes cluster. This string is used to contruct the AWS IAM permissions and roles."
  type        = "string"
  default     = "alb"
}

variable "aws_max_retries" {
  description = "Maximum number of times to retry the aws calls."
  type        = "number"
  default     = 10
}

variable "aws_tags" {
  description = "Common AWS tags to be applied to all AWS objects being created."
  type        = "map"
  default     = {}
}





