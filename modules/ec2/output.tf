output "instance_id" {
  description = "ID of the instance"
  value       = aws_instance.backend.id
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = aws_instance.backend.private_ip
}

output "iam_instance_profile" {
  description = "Instance profile value of the instance"
  value       = aws_iam_instance_profile.wordpress_profile.name
}

output "account_id" {
  description = "AWS Account ID"
  value       = data.aws_caller_identity.current.account_id
}