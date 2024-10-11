output "public_instances" {
  value = module.aws_instances.public_instance_ips
}

output "private_instances" {
  value = module.aws_instances.private_instance_ips
}

output "key_path" {
  value = module.keypair.private_key_path
}