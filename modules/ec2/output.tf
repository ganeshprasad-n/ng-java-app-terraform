output "instance_id" {
  value = aws_instance.backend.id
}

output "private_ip" {
  value = aws_instance.backend.private_ip
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.wordpress_profile.name
}