data "aws_iam_role" "existing_role" {
  name = "eks-cluster-role"
}

resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"
  count = length(data.aws_iam_role.existing_role) > 0 ? 0 : 1

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  depends_on = [module.eks]
}

resource "aws_db_instance" "database" {
  count                 = var.create_rds && !aws_db_instance.database[0] ? 1 : 0
  identifier            = "portal26-${var.tenant_name}"
  allocated_storage     = 20
  engine                = "postgres"
  engine_version        = "13.7"
  instance_class        = "db.r5.large"
  username              = "dbmaster"  # Change to a valid master user name
  password              = "ValidPassword123!"
  publicly_accessible   = true
  final_snapshot_identifier = "final-snapshot-${var.tenant_name}"


  # Additional RDS-specific settings
  multi_az              = false
  storage_type          = "gp2"
  backup_retention_period = 7
  # ... other RDS settings

  tags = {
    Name        = "portal26-${var.tenant_name}-db"
    Environment = "Production"
  }
}

resource "aws_secretsmanager_secret" "db_credentials" {
  count = var.create_secrets_manager ? 1 : 0  
  name = "portal26-${var.tenant_name}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  count = var.create_secrets_manager && !aws_secretsmanager_secret.db_credentials[0] ? 1 : 0
  secret_id    = aws_secretsmanager_secret.db_credentials[count.index].id
  secret_string = jsonencode({
    username = "opstra"
    password = "ValidPassword123!"
  })
}


resource "aws_s3_bucket" "s3_bucket" {
  count  = var.create_s3_bucket && !aws_s3_bucket.s3_bucket[0] ? 1 : 0
  bucket = "portal26-${var.tenant_name}-unique"  # Adjust to ensure uniqueness
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  count = var.create_log_group && length(module.eks.aws_cloudwatch_log_group.this) == 0 ? 1 : 0
}

resource "aws_kms_alias" "kms_alias" {
  count = var.create_kms_alias && length(module.eks.module.kms.aws_kms_alias.this["cluster"]) == 0 ? 1 : 0
  name  = "alias/eks/eks-cluster-developer"
  target_key_id = length(module.eks.kms_key_arn) > 0 ? module.eks.kms_key_arn[0] : null
  depends_on = [module.eks]
}