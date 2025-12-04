# Store RDS password in Parameter Store
resource "aws_ssm_parameter" "db_password" {
  name        = "/${var.project_name}/${var.environment}/db/password"
  description = "RDS master password"
  type        = "SecureString"
  value       = var.db_password

  tags = {
    Name        = "${var.project_name}-db-password"
    Environment = var.environment
  }
}

# Store RDS endpoint
resource "aws_ssm_parameter" "db_endpoint" {
  name        = "/${var.project_name}/${var.environment}/db/endpoint"
  description = "RDS endpoint"
  type        = "String"
  value       = aws_db_instance.main.endpoint

  tags = {
    Name        = "${var.project_name}-db-endpoint"
    Environment = var.environment
  }
}

# Store DB name
resource "aws_ssm_parameter" "db_name" {
  name        = "/${var.project_name}/${var.environment}/db/name"
  description = "RDS database name"
  type        = "String"
  value       = var.db_name

  tags = {
    Name        = "${var.project_name}-db-name"
    Environment = var.environment
  }
}