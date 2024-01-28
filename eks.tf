# eks.tf

provider "aws" {
  region = "us-east-1"  # Update with your preferred AWS region
}

# terraform {
#   required_providers {
#     kubectl = {
#       source  = "gavinbunney/kubectl"
#       version = "~>1.14.0"
#     }
#   }
# }

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.15.3"

  cluster_name    = "eks-cluster-devloper"
  cluster_version = "1.27"

  cluster_endpoint_public_access  = true


  vpc_id                   = "vpc-02696c43f90025854"
  subnet_ids               = ["subnet-04ee01c8a4698945e", "subnet-09100155c53dac5c1"]
  control_plane_subnet_ids = ["subnet-04ee01c8a4698945e", "subnet-09100155c53dac5c1"]

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
# provider "kubectl" {
#   config_path    = "~/.kube/config"  # Adjust the path as needed
#   context        = module.eks.cluster_id
#   cluster        = module.eks.cluster_endpoint
#   user           = "aws"
#   load_config_file = false
# }


# Create an AWS Route 53 DNS zone for "arcstone.ai"
resource "aws_route53_zone" "arcstone_zone" {
  name = "arcstone.ai"
  force_destroy = true
  depends_on = [module.eks]
}

data "aws_cloudwatch_log_groups" "existing_log_groups" {
  name_prefix = "/aws/eks/eks-cluster-devloper/cluster"
}

resource "aws_cloudwatch_log_group" "this" {
  count = length(data.aws_cloudwatch_log_groups.existing_log_groups.names) > 0 ? 0 : 1
  name  = "/aws/eks/eks-cluster-devloper/cluster"

}