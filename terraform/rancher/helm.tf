resource "kubernetes_service_account" "tiller" {
    metadata {
        name = "tiller"
        namespace = "kube-system"  
        labels = {
            "app.kubernetes.io/name" = "tiller"
            "app.kubernetes.io/component"  = "helm"
            "app.kubernetes.io/managed-by" = "terraform"
        }
    }
}

resource "kubernetes_cluster_role_binding" "tiller" {
    metadata {
        name = "tiller"
        labels = {
            "app.kubernetes.io/name" = "tiller"
            "app.kubernetes.io/component"  = "helm"
            "app.kubernetes.io/managed-by" = "terraform"
        }
    }
    role_ref {
        api_group   = "rbac.authorization.k8s.io"
        kind        = "ClusterRole"
        name        = "cluster-admin"
    }
    subject {
        kind        = "ServiceAccount"
        name        = "${kubernetes_service_account.tiller.metadata.0.name}"
        namespace   = "${kubernetes_service_account.tiller.metadata.0.namespace}"
    }  
}

data "helm_repository" "stable" {
    name = "stable"
    url  = "https://kubernetes-charts.storage.googleapis.com"
}

data "helm_repository" "incubator" {
    name = "incubator"
    url  = "http://storage.googleapis.com/kubernetes-charts-incubator"
}

data "helm_repository" "jetstack" {
    name = "jetstack"
    url  = "https://charts.jetstack.io"
}

# Latest: Recommended for trying out the newest features of Rancher
# See https://rancher.com/docs/rancher/v2.x/en/installation/ha/helm-rancher/
data "helm_repository" "rancher_latest" {
    name = "rancher-latest"
    url  = "https://releases.rancher.com/server-charts/latest"
}

# Stable: Recommended for production environments
# See https://rancher.com/docs/rancher/v2.x/en/installation/ha/helm-rancher/
data "helm_repository" "rancher_stable" {
    name = "rancher-stable"
    url  = "https://releases.rancher.com/server-charts/stable"
}


