aws_region      = "us-east-1"
aws_profile     = "devops"
aws_environment = "dev"
aws_project     = "lab1"
aws_owner       = "devops-team"

aws_vpc_config = {
  name                         = "lab1"
  cidr_block                   = "10.10.0.0/16"
  enable_dns_support           = true
  enable_dns_hostnames         = true
  public_subnets_cidr          = ["10.10.1.0/24", "10.10.3.0/24"]
  private_subnets_cidr         = ["10.10.2.0/24", "10.10.4.0/24"]
  number_of_availability_zones = 2
  enable_nat_gateway           = true
}

aws_public_instance_count  = 2
aws_private_instance_count = 2
aws_instance_type          = "t2.micro"