
# Application Load Balancer (ALB) Ingress Controller Deployment Manifest.
# This manifest details sensible defaults for deploying an ALB Ingress Controller.
# GitHub: https://github.com/kubernetes-sigs/aws-alb-ingress-controller


resource "kubernetes_deployment" "this" {
  metadata {
    name = "${var.name}"
    namespace = "${var.namespace}"
    labels {
      "app.kubernetes.io/name" = "${var.name}"
      "app.kubernetes.io/version" = "${var.controller_version}"
      "app.kubernetes.io/component"  = "aws-alb-ingress-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
    annotations {
      "field.cattle.io/description" = "AWS ALB Ingress Controller"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels {
        name = "${var.name}"
      }
    }
    template {
      metadata {
        labels {
          name = "${var.name}"
        }
        annotations {}
      }
      spec {
        dns_policy = "ClusterFirst"
        restart_policy = "Always"
        container {
          name                     = "server"
          image                    = "${var.container_image_uri}:v${var.controller_version}"
          image_pull_policy        = "Always"
          termination_message_path = "/dev/termination-log"
          args = [
            "--ingress-class=${var.ingress_class}",
            "--cluster-name=${var.cluster_name}",
            "--aws-max-retries=${var.aws_max_retries}",
          ]
          volume_mount {
            mount_path = "/var/run/secrets/kubernetes.io/serviceaccount"
            name       = "${kubernetes_service_account.this.default_secret_name}"
            read_only  = true
          }
          port {
            name           = "health"
            container_port = 10254
            protocol       = "TCP"
          }
          readiness_probe {
            http_get {
              path   = "/healthz"
              port   = "health"
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds = 60
            timeout_seconds = 3
          }
          liveness_probe {
            http_get {
              path   = "/healthz"
              port   = "health"
              scheme = "HTTP"
            }
            initial_delay_seconds = 60
            period_seconds  = 60
          }
        }
        volume {
          name = "${kubernetes_service_account.this.default_secret_name}"
          secret {
            secret_name = "${kubernetes_service_account.this.default_secret_name}"
          }
        }
        service_account_name = "${kubernetes_service_account.this.metadata.0.name}"
        termination_grace_period_seconds = 60
      }
    }
  }
}