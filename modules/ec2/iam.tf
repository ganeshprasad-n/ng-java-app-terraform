# EC2 Role
resource "aws_iam_role" "wordpress_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = {
    Name        = "${var.project_name}-ec2-role"
    Environment = var.environment
  }
}

# Policy
resource "aws_iam_policy" "rds_and_ssm_access" {
  name   = "${var.project_name}-ssm-access"
  policy = data.aws_iam_policy_document.rds_and_ssm_access.json
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_ssm_policy" {
  role       = aws_iam_role.wordpress_role.name
  policy_arn = aws_iam_policy.rds_and_ssm_access.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "wordpress_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.wordpress_role.name
}