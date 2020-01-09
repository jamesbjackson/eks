

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

  values = [
    <<-EOF
      addLocal: auto
      hostname: rancher.connectedproducts.io
      ingress:
        extraAnnotations:
          alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-Ext-2018-06
          alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:eu-west-2:376405082911:certificate/62b0389b-1253-4ba4-9f1f-efd722beaeb2
          alb.ingress.kubernetes.io/scheme: internet-facing
          kubernetes.io/ingress.class: alb
      tls: external
    EOF
  ]

  depends_on = [ 
    helm_release.aws_alb_ingress_controller,
    helm_release.cert_manager
  ]  

  
}
