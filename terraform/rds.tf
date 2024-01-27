
resource "aws_iam_role" "eks_cluster" {
  name = "eks-cluster-role"

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
}

resource "aws_db_instance" "database" {
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
  name = "portal26-${var.tenant_name}-db-credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "opstra"
    password = "ValidPassword123!"
  })
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "portal26-${var.tenant_name}-unique"  # Adjust to ensure uniqueness
}

