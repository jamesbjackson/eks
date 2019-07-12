
provider "aws" {}

terraform {
   backend "s3" {
      bucket = "example-terraform-eks-gir01"
      key    = "k8s"
      region = "us-east-1"
   }
}

# Remote backend for EKS
   data "terraform_remote_state" "eks" {
   backend = "s3" 
   config = {
      bucket = "example-terraform-eks-gir01"
      key    = "eks"
      region = "us-east-1"
   }
}


provider "kubernetes" {
  cluster_ca_certificate = "${base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)}"
  host                   = "${data.aws_eks_cluster.cluster.endpoint}"
  load_config_file       = false

  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["token", "-i", "${data.aws_eks_cluster.cluster.name}"]
    command     = "aws-iam-authenticator"
  }
}

resource "kubernetes_config_map" "aws_auth" {
   metadata {
      name = "aws-auth"
      namespace = "kube-system"
   }
   data {
        "mapRoles" = <<MAPROLES
          - rolearn: ${data.terraform_remote_state.eks.node_iam_role}
            username: system:node:{{EC2PrivateDNSName}}
            groups:
              - system:bootstrappers
              - system:nodes
MAPROLES
   }
}
resource "kubernetes_service_account" "tiller" {
   depends_on = [ "kubernetes_config_map.aws_auth" ]
   metadata {
      name = "tiller"
      namespace = "kube-system"
   }
}