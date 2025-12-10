# Project Configuration
project_name = "ng-java-app-terraform"
environment  = "staging"
aws_region   = "us-east-1"

# Network Configuration
vpc_cidr      = "10.0.0.0/16"
default-route = "0.0.0.0/0"

# EC2 Configuration
ec2_instance_type = "t3.micro" # Backend services
alb_instance_type = "t3.micro" # App tier instances

desired_capacity = 1
min_size         = 1
max_size         = 2

# RDS Configuration
db_engine         = "mysql"
db_engine_version = "8.0"
db_instance_class = "db.t3.micro"
db_storage_size   = 20
db_storage_type   = "gp3"
db_name           = "accounts"
db_username       = "admin"
db_password       = "Admin#54321"

# ALB Configuration
loadbalancer_type = "application"

# CloudWatch / Autoscaling thresholds
cpu_high_threshold   = 70
cpu_low_threshold    = 30
scale_out_adjustment = 2
scale_in_adjustment  = -1