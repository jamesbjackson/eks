

# aws-alb-ingress-controller satisfies Kubernetes ingress resources by provisioning Application Load Balancers.
# See https://github.com/helm/charts/tree/master/incubator/aws-alb-ingress-controller


resource "helm_release" "aws_alb_ingress_controller" {  
  name       = "aws-alb-ingress-controller"
  namespace  = "kube-system" 
  repository = "${data.helm_repository.incubator.metadata.0.name}"
  chart      = "aws-alb-ingress-controller"
  version    = "0.1.10"
  
  set {
    name  = "clusterName"
    value = "kops-rancher.connectedproducts.io"
  }

  set {
    name  = "autoDiscoverAwsRegion"
    value = "true"
  }

  set {
    name  = "autoDiscoverAwsVpcID"
    value = "true"
  }

  set {
    name  = "rbac.create"
    value = "true"
  }  

  set {
    name  = "scope.ingressClass"
    value = "alb"
  }

  set {
    name  = "scope.singleNamespace"
    value = "false"
  }
  
}
