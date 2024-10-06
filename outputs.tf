# Root outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = module.nat.nat_gateway_id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = module.route_tables.public_route_table_id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = module.route_tables.private_route_table_id
}

output "public_security_group_id" {
  description = "ID of the public EC2 security group"
  value       = module.security_groups.public_sg_id
}

output "private_security_group_id" {
  description = "ID of the private EC2 security group"
  value       = module.security_groups.private_sg_id
}

output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = module.ec2.public_instance_id
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = module.ec2.private_instance_id
}

output "public_instance_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = module.ec2.public_instance_public_ip
}