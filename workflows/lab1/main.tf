
# List all avalability zones in the region
data "aws_availability_zones" "available" {}
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.aws_vpc_config.number_of_availability_zones)
}

# Create VPC with public and private subnets
module "vpc" {
  source = "../../modules/vpc"

  name                 = var.aws_project
  vpc_cidr             = var.aws_vpc_config.cidr_block
  enable_dns_hostnames = var.aws_vpc_config.enable_dns_hostnames
  enable_dns_support   = var.aws_vpc_config.enable_dns_support
  public_subnets_cidr  = var.aws_vpc_config.public_subnets_cidr
  private_subnets_cidr = var.aws_vpc_config.private_subnets_cidr
  availability_zones   = local.selected_azs
  enable_nat_gateway   = var.aws_vpc_config.enable_nat_gateway
}

# # Create Key Pair
# module "keypair" {
#   source = "../../modules/keypair"

#   name      = var.aws_project
#   algorithm = "ED25519"
# }

# # Get my public IP address
# data "http" "my_ip" {
#   url = "http://checkip.amazonaws.com"
# }

# Create Security Groups for Public Subnets
module "public_security_group" {
  source      = "../../modules/security_groups"
  name        = "${var.aws_project}-public"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for public subnets"
  ingress_rules_with_cidr = [
    {
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      ip        = var.my_ip
    }
  ]
  egress_rules_with_cidr = [
    {
      protocol = "-1"
      ip       = "0.0.0.0/0"
    }
  ]
}

# Create Security Groups for Private Subnets
module "private_security_group" {
  source      = "../../modules/security_groups"
  name        = "${var.aws_project}-private"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for private subnets"
  ingress_rules_with_security_group = [
    {
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      security_group_id = module.public_security_group.id
    }
  ]
  egress_rules_with_cidr = [
    {
      protocol = "-1"
      ip       = "0.0.0.0/0"
    }
  ]
}

# Create EC2 instances
module "aws_instances" {
  source = "../../modules/ec2"

  name                   = var.aws_project
  instance_type          = var.aws_instance_type
  public_subnets_id      = module.vpc.public_subnets
  private_subnets_id     = module.vpc.private_subnets
  public_sgs_id          = [module.public_security_group.id]
  private_sgs_id         = [module.private_security_group.id]
  public_instance_count  = var.aws_public_instance_count
  private_instance_count = var.aws_private_instance_count
  key_name               = var.aws_key_name
}