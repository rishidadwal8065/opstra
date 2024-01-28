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

terraform {
  backend "s3" {
    bucket         = "portal26-tf-rishia"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

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

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "portal26-${var.tenant_name}-unique"  
}


# resource "aws_iam_role" "eks_cluster" {
#   name = "eks-cluster-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "eks.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
#   depends_on = [module.eks]
# }


resource "aws_iam_role_policy_attachment" "secrets_manager_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = module.eks.worker_groups_role_name
}

# resource "aws_db_instance" "rds_instance" {
#   identifier           = "portal26-${var.tenant_name}"
#   allocated_storage    = 20
#   engine               = "postgres"
#   engine_version       = "13.7"
#   instance_class       = "db.r5.large"
#   username             = "dbmaster"
#   password             = "ValidPassword123!"
#   availability_zone    = "us-east-1" # Replace with your desired availability zone
#   publicly_accessible  = false
#   final_snapshot_identifier = "final-snapshot-${var.tenant_name}"

#   multi_az              = false
#   storage_type          = "gp2"
#   backup_retention_period = 7

#   tags = {
#     Name = "portal26-${var.tenant_name}"
#     Environment = "dev"
#   }
# }

# resource "aws_secretsmanager_secret" "db_secret" {
#   name = "portal26.${var.tenant_name}.db"
# }

# resource "aws_secretsmanager_secret_version" "db_secret_version" {
#   secret_id = aws_secretsmanager_secret.db_secret.id
#   secret_string = <<EOT
# {
#   "url": "jdbc:postgresql://${aws_db_instance.rds_instance.endpoint}:5432/portal26-${var.tenant_name}",
#   "username": "dbmaster",
#   "password": "ValidPassword123!"
# }
# EOT
# }
