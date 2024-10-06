# modules/ec2/main.tf

# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Public EC2 Instance
resource "aws_instance" "public" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.public_sg_id]
  associate_public_ip_address = true

  key_name = var.key_name

  tags = {
    Name = "${var.environment}-public-ec2"
  }
}

# Private EC2 Instance
resource "aws_instance" "private" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.private_sg_id]

  key_name = var.key_name

  tags = {
    Name = "${var.environment}-private-ec2"
  }
}