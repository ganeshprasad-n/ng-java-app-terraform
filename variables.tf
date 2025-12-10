variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "default-route" {
  description = "default"
  type        = string
}

variable "ami_id" {
  description = "Golden AMI ID for ASG instances"
  type        = string
}

variable "backend_ami_id" {
  description = "AMI ID for backend server (RabbitMQ + Elasticsearch)"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "db_name" {
  description = "Name of the RDS database"
  type        = string
}

variable "db_username" {
  description = "Username for the RDS database"
  type        = string
}

variable "db_password" {
  description = "Master password for the RDS database"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_storage_size" {
  description = "RDS storage size in GB"
  type        = number
}

variable "db_engine_version" {
  description = "RDS MySQL engine version"
  type        = string
}

variable "db_engine" {
  description = "Database Engine Type"
  type        = string
}

variable "db_storage_type" {
  description = "Database Storage Type"
  type        = string
}

variable "loadbalancer_type" {
  description = "Type of LoadBalancer"
  type        = string
}

variable "min_size" {
  description = "Minimum size for ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum size for ASG"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity for ASG"
  type        = number
}

variable "alb_instance_type" {
  description = "EC2 instance type"
  type        = string
}

#Cloudwatch variables
variable "cpu_high_threshold" {
  description = "CPU % threshold for scale-out alarm"
  type        = number
  default     = 70
}

variable "cpu_low_threshold" {
  description = "CPU % threshold for scale-in alarm"
  type        = number
  default     = 30
}

variable "scale_out_adjustment" {
  description = "Number of instances to add on scale-out"
  type        = number
  default     = 2
}

variable "scale_in_adjustment" {
  description = "Number of instances to remove on scale-in"
  type        = number
  default     = -1
}