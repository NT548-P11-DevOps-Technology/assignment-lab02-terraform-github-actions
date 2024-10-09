
# List all avalability zones in the region
data "aws_availability_zones" "available" {}
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.aws_vpc_config.number_of_availability_zones)
}

# Create VPC with public and private subnets
module "vpc" {
  source = "../../modules/vpc"

  name                 = "lab1"
  vpc_cidr             = var.aws_vpc_config.cidr_block
  enable_dns_hostnames = var.aws_vpc_config.enable_dns_hostnames
  enable_dns_support   = var.aws_vpc_config.enable_dns_support
  public_subnets_cidr  = var.aws_vpc_config.public_subnets_cidr
  private_subnets_cidr = var.aws_vpc_config.private_subnets_cidr
  availability_zones   = local.selected_azs
  enable_nat_gateway   = var.aws_vpc_config.enable_nat_gateway
}

# Create Key Pair
module "keypair" {
  source = "../../modules/keypair"

  name      = "lab1"
  algorithm = "ED25519"
}

# Get my public IP address
data "http" "my_ip" {
  url = "http://checkip.amazonaws.com"
}

# Create Security Groups for Public Subnets
module "public_security_group" {
  source      = "../../modules/security_groups"
  name        = "lab1-public"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for public subnets"
  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [data.http.my_ip.response_body]
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Create Security Groups for Private Subnets
module "private_security_group" {
  source      = "../../modules/security_groups"
  name        = "lab1-private"
  vpc_id      = module.vpc.vpc_id
  description = "Security Group for private subnets"
  ingress_rules = [
    {
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      security_group_id = module.public_security_group.id
    }
  ]
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

# Get Ubuntu 20.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Create EC2 instances
resource "aws_instance" "public_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.public_security_group.id]
  key_name               = module.keypair.key_name

  tags = {
    Name = "public-instance"
  }
}

resource "aws_instance" "private_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [module.private_security_group.id]
  key_name               = module.keypair.key_name

  tags = {
    Name = "private-instance"
  }
}

# module "public_instance" {
#   source = "../../modules/ec2"

#   name               = "public"
#   ami_id             = data.aws_ami.ubuntu.id
#   instance_type      = "t2.micro"
#   subnet_id          = module.vpc.public_subnets[0]
#   security_group_ids = [module.public_security_group.id]
#   key_name           = module.keypair.key_name
# }

# module "private_instance" {
#   source = "../../modules/ec2"

#   name               = "private"
#   ami_id             = data.aws_ami.ubuntu.id
#   instance_type      = "t2.micro"
#   subnet_id          = module.vpc.private_subnets[0]
#   security_group_ids = [module.private_security_group.id]
#   key_name           = module.keypair.key_name
# }