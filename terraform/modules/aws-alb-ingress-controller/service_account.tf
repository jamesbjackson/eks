
# Application Load Balancer (ALB) Ingress Controller Deployment Manifest.
# This manifest details sensible defaults for deploying an ALB Ingress Controller.
# GitHub: https://github.com/kubernetes-sigs/aws-alb-ingress-controller

resource "kubernetes_service_account" "this" {
  metadata {
    name = "${var.name}"
    namespace = "${var.namespace}"
    labels {
      "app.kubernetes.io/name" = "${var.name}"
      "app.kubernetes.io/component"  = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}
