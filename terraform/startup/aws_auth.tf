

resource "kubernetes_config_map" "aws_auth" {
   metadata { 
     name = "aws-auth"
     namespace = "kube-system" 
     labels = {
        "app.kubernetes.io/managed-by" = "terraform"
     }
   }
   data = {
      mapRoles = <<EOF
         - rolearn: ${var.worker_node_iam_role_arn}
            username: system:node:{{EC2PrivateDNSName}}
            groups:
               - system:bootstrappers
               - system:nodes
      EOF
   }
}

