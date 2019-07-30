
terraform {
   required_version = ">= 0.12.5"
   backend "remote" {
      organization = "connectedcloud"
      workspaces {
         name = "eks-kops-rancher"
      }
   }
}