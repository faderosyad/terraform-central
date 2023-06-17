resource "kubernetes_namespace_v1" "cert_manager_ns" {
  metadata {
    labels = {
      managed-by = "tf-managed"
    }
    name = "cert-manager"
  }
}

resource "helm_release" "cert_manager" {
  depends_on = [kubernetes_namespace_v1.cert_manager_ns]
  name       = "cert-manager"
  namespace  = kubernetes_namespace_v1.cert_manager_ns.metadata[0].name

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.12.2"
  values     = ["${file("values.yaml")}"]

  set {
    name  = "installCRDs"
    value = "true"
  }
}
