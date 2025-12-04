# Backend Services EC2 (RabbitMQ + Elasticsearch)
resource "aws_instance" "backend" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.ec2_instance_type

  iam_instance_profile = aws_iam_instance_profile.wordpress_profile.name

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = false

  user_data = base64encode(local.ec2_userdata_script)

  tags = {
    Name        = "${var.project_name}-backend-services"
    Environment = var.environment
  }
}