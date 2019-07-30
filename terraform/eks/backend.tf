
terraform {
   backend "remote" {
      organization = "connectedcloud"
      workspaces {
         name = "eks-cloudformation"
      }
   }
}