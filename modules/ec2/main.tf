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

locals {
  ec2_ami = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
}

# Public EC2 Instance
resource "aws_instance" "public_instances" {
  #checkov:skip=CKV_AWS_8 
  #checkov:skip=CKV2_AWS_41
  count         = var.public_instance_count
  ami           = local.ec2_ami
  instance_type = var.instance_type

  subnet_id              = var.public_subnets_id[count.index % length(var.public_subnets_id)]
  vpc_security_group_ids = var.public_sgs_id
  key_name               = var.key_name

  tags = {
    Name = "${var.name}-public-instance-${count.index}"
  }
  ebs_optimized          = true
  monitoring             = true

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    encrypted  = true  
  }

  metadata_options {
    http_tokens = "required"  
    http_endpoint = "enabled"  
  }
}

# Private EC2 Instance
resource "aws_instance" "private_instances" {
  #checkov:skip=CKV_AWS_8 
  #checkov:skip=CKV2_AWS_41
  count         = var.private_instance_count
  ami           = local.ec2_ami
  instance_type = var.instance_type

  subnet_id              = var.private_subnets_id[count.index % length(var.private_subnets_id)]
  vpc_security_group_ids = var.private_sgs_id
  key_name               = var.key_name
  tags = {
    Name = "${var.name}-private-instance-${count.index}"
  }

  # ebs_optimized          = true
  # monitoring             = true

  # root_block_device {
  #   volume_size = 10
  #   volume_type = "gp2"
  #   encrypted  = true  
  # }

  metadata_options {
    http_tokens = "required"  
    http_endpoint = "enabled"  
  }
}
