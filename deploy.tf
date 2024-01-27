# provider "kubernetes" {
#   config_path = "~/.kube/config"
# }

# variable "kubeconfig_path" {
#   description = "Path to the kubeconfig file"
#   default     = "~/.kube/config"  # Set the default path to your kubeconfig file
# }

# resource "null_resource" "apply_manifest" {
#   triggers = {
#     manifest_content = file("${path.module}/hello-world-deployment.yaml")
#   }

#   provisioner "local-exec" {
#     command = <<-EOT
#       aws eks --region us-east-1 update-kubeconfig --name eks-cluster-devloper && \
#       kubectl apply -f ${path.module}/hello-world-deployment.yaml
#     EOT
#   }
#   depends_on = [module.eks]
# }

