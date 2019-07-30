
provider "kubernetes" {
   load_config_file = true
   exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["token", "-i", "${var.cluster_name}"]
      command     = "aws-iam-authenticator"
   }
}

provider "helm" {
   install_tiller = true
   init_helm_home = true
   service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
   namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
   tiller_image = "gcr.io/kubernetes-helm/tiller:v2.12.3"
}



# Netdata 
# https://github.com/netdata/helmchart/