output "public_ip_of_public_instances" {
  value = aws_instance.public_instances[*].public_ip
}

output "private_ip_of_public_instances" {
  value = aws_instance.public_instances[*].private_ip
}

output "public_ip_of_private_instances" {
  value = aws_instance.private_instances[*].public_ip
}

output "private_ip_of_private_instances" {
  value = aws_instance.private_instances[*].private_ip
}
