

# Declare the "tenant_name" variable
variable "tenant_name" {
  description = "Name of the tenant for the Route 53 CNAME record"
  type        = string
}

variable "create_rds" {
  description = "Set to true to create RDS DB instance, false to skip"
  type        = bool
  default     = true
}

variable "create_secrets_manager" {
  description = "Set to true to create Secrets Manager Secret, false to skip"
  type        = bool
  default     = true
}

variable "create_s3_bucket" {
  description = "Set to true to create S3 Bucket, false to skip"
  type        = bool
  default     = true
}

variable "create_kms_alias" {
  description = "Set to true to create KMS Alias, false to skip"
  type        = bool
  default     = true
}

variable "create_log_group" {
  description = "Set to true to create CloudWatch Log Group, false to skip"
  type        = bool
  default     = true
}

variable "tenant_name" {
  description = "Name of the tenant for various resources"
  type        = string
  default     = "opstra"  # Update with your desired default value
}
