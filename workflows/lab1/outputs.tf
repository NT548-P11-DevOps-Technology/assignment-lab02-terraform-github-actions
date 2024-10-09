output "public_ip_of_public_instance" {
  value = aws_instance.public_instance.public_ip
}

output "private_ip_of_private_instance" {
  value = aws_instance.private_instance.private_ip
}