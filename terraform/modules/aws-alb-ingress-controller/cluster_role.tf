
# Application Load Balancer (ALB) Ingress Controller Deployment Manifest.
# This manifest details sensible defaults for deploying an ALB Ingress Controller.
# GitHub: https://github.com/kubernetes-sigs/aws-alb-ingress-controller


resource "kubernetes_cluster_role" "this" {
  metadata {
    name = "${var.name}"
    namespace = "${var.namespace}"
    labels {
      "app.kubernetes.io/name" = "${var.name}"
      "app.kubernetes.io/component"  = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  rule {
    api_groups  = ["", "extensions"]
    resources   = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs       = ["create", "get", "list", "update", "watch", "patch"]
  }
  rule {
    api_groups  = ["", "extensions"]
    resources   = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs       = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "this" {
  metadata {
    name = "${var.name}"
    namespace = "${var.namespace}"
    labels {
      "app.kubernetes.io/name" = "${var.name}"
      "app.kubernetes.io/component"  = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
  role_ref {
    api_group   = "rbac.authorization.k8s.io"
    kind        = "ClusterRole"
    name        = "${kubernetes_cluster_role.this.metadata.0.name}"
    namespace   = "${kubernetes_cluster_role.this.metadata.0.namespace}"
  }
  subjects {
    api_group   = ""
    kind        = "ServiceAccount"
    name        = "${kubernetes_service_account.this.metadata.0.name}"
    namespace   = "${kubernetes_service_account.this.metadata.0.namespace}"
  }
}
