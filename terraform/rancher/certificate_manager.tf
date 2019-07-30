

# If you are running kubectl v1.12 or below, you will need to add the --validate=false flag to your kubectl apply 
# command above else you will receive a validation error relating to the caBundle field of the ValidatingWebhookConfiguration 
# resource. This issue is resolved in Kubernetes 1.13 onwards. 
# More details can be found in https://github.com/kubernetes/kubernetes/issues/69590.
#
# See https://docs.cert-manager.io/en/latest/getting-started/install/kubernetes.html

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
    labels = {
        "app.kubernetes.io/managed-by" = "terraform"
        "certmanager.k8s.io/disable-validation" = "true"        
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

resource "k8s_manifest" "certificates_certmanager_k8s_io" {
  content = "${file("${path.cwd}/../manifests/cert_manager/releases/0.8/certificates_certmanager_k8s_io.yaml")}"
}

resource "k8s_manifest" "challenges_certmanager_k8s_io" {
  content = "${file("${path.cwd}/../manifests/cert_manager/releases/0.8/challenges_certmanager_k8s_io.yaml")}"
}

resource "k8s_manifest" "clusterissuers_certmanager_k8s_io" {
  content = "${file("${path.cwd}/../manifests/cert_manager/releases/0.8/clusterissuers_certmanager_k8s_io.yaml")}"
}

resource "k8s_manifest" "issuers_certmanager_k8s_io" {
  content = "${file("${path.cwd}/../manifests/cert_manager/releases/0.8/issuers_certmanager_k8s_io.yaml")}"
}

resource "k8s_manifest" "orders_certmanager_k8s_io" {
  content = "${file("${path.cwd}/../manifests/cert_manager/releases/0.8/orders_certmanager_k8s_io.yaml")}"
}

resource "helm_release" "cert_manager" {  
  name       = "cert-manager"
  namespace  = "${kubernetes_namespace.cert_manager.metadata.0.name}" 
  repository = "${data.helm_repository.jetstack.metadata.0.name}"
  chart      = "cert-manager"
  version    = "0.8.1"
  depends_on = [ 
    k8s_manifest.certificates_certmanager_k8s_io, 
    k8s_manifest.challenges_certmanager_k8s_io,
    k8s_manifest.clusterissuers_certmanager_k8s_io,
    k8s_manifest.issuers_certmanager_k8s_io,
    k8s_manifest.orders_certmanager_k8s_io 
  ]
}
