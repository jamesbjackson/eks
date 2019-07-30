
provider "kubernetes" {
   load_config_file = true
   exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["token", "-i", "${var.cluster_name}"]
      command     = "aws-iam-authenticator"
   }
}