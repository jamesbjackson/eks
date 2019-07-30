
provider "kubernetes" {
   load_config_file = true
}

provider "helm" {
    namespace = "${kubernetes_service_account.tiller.metadata.0.namespace}"
    service_account = "${kubernetes_service_account.tiller.metadata.0.name}"
    tiller_image = "gcr.io/kubernetes-helm/tiller:v2.14.1"
}