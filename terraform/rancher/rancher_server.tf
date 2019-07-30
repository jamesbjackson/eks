

# aws-alb-ingress-controller satisfies Kubernetes ingress resources by provisioning Application Load Balancers.
# See https://github.com/helm/charts/tree/master/incubator/aws-alb-ingress-controller

# For ALB Ingress Controller annotations
# See https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/


resource "kubernetes_namespace" "cattle_system" {
    metadata {
        name = "cattle-system"
        labels = {
            "app.kubernetes.io/managed-by" = "terraform",
            "field.cattle.io/projectId" = "placeholder"
        }
        annotations = {
            "cattle.io/status" = "placeholder"
            "field.cattle.io/projectId" = "placeholder"
            "lifecycle.cattle.io/create.namespace-auth" = "placeholder"
        }
    }
    lifecycle {
        ignore_changes = [
            metadata[0].annotations["cattle.io/status"],
            metadata[0].labels["field.cattle.io/projectId"],
            metadata[0].annotations["field.cattle.io/projectId"],
            metadata[0].annotations["lifecycle.cattle.io/create.namespace-auth"]
        ]
    }    
}

resource "helm_release" "rancher" {  
  name       = "rancher"
  namespace  = "${kubernetes_namespace.cattle_system.metadata.0.name}"
  repository = "${data.helm_repository.rancher_stable.metadata.0.name}"
  chart      = "rancher"
  version    = "2.2.6"

  set {
    name  = "hostname"
    value = "rancher.connectedproducts.io"
  }

  set {
    name  = "addLocal"
    value = "auto"
  }

  set {
    name  = "tls"
    value = "external"
  } 

  set {
    name  = "scope.ingressClass"
    value = "alb"
  }

  set {
    name  = "scope.singleNamespace"
    value = "false"
  }

  set_string {
    name  = "ingress.extraAnnotations.kubernetes.io/ingress.class"
    value = ": alb"
  }

  set_string {
    name  = "ingress.extraAnnotations.alb.ingress.kubernetes.io/scheme"
    value = ": internet-facing"
  }

  depends_on = [ 
    helm_release.aws_alb_ingress_controller,
    helm_release.cert_manager
  ]  

  
}
