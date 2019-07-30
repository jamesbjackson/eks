
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

