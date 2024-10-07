# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.region
}

module "keypair" {
  source = "./modules/keypair"

  environment = var.environment
}

module "vpc" {
  source = "./modules/vpc"

  region               = var.region
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnets_cidr  = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones   = var.availability_zones
}

module "nat" {
  source = "./modules/nat"

  environment      = var.environment
  public_subnet_id = module.vpc.public_subnets[0]

  depends_on = [module.vpc]
}

module "route_tables" {
  source = "./modules/route_tables"

  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.vpc.internet_gateway_id
  nat_gateway_id      = module.nat.nat_gateway_id
  public_subnet_ids   = module.vpc.public_subnets
  private_subnet_ids  = module.vpc.private_subnets

  depends_on = [module.vpc, module.nat]
}

module "security_groups" {
  source = "./modules/security_groups"

  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  allowed_ip  = var.allowed_ip

  depends_on = [module.vpc]
}

module "ec2" {
  source = "./modules/ec2"

  environment       = var.environment
  instance_type     = var.instance_type
  public_subnet_id  = module.vpc.public_subnets[0]
  private_subnet_id = module.vpc.private_subnets[0]
  public_sg_id      = module.security_groups.public_sg_id
  private_sg_id     = module.security_groups.private_sg_id
  key_name          = module.keypair.key_name

  depends_on = [
    module.vpc,
    module.route_tables,
    module.security_groups,
    module.keypair
  ]
}