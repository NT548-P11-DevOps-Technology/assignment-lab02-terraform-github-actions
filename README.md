# AWS Infrastructure with Terraform

This project uses Terraform to deploy a secure AWS infrastructure consisting of a VPC with public and private subnets, NAT Gateway, security groups, and EC2 instances.

## Architecture

- VPC with public and private subnets across two availability zones
- Internet Gateway for public subnets
- NAT Gateway for private subnets
- Security groups for controlling access
- EC2 instances in both public and private subnets

## Prerequisites

1. [Terraform](https://www.terraform.io/downloads.html) (>= 1.2.0)
2. [AWS CLI](https://aws.amazon.com/cli/) installed and configured
3. An AWS account with appropriate permissions

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd aws-terraform-infrastructure
```

### 2. Create SSH Key Pair

```bash
aws ec2 create-key-pair --key-name my-key-pair --query 'KeyMaterial' --output text > my-key-pair.pem
chmod 400 my-key-pair.pem
```

### 3. Configure Variables

Create a `terraform.tfvars` file:

```hcl
region = "us-east-1"
environment = "dev"
vpc_cidr = "10.0.0.0/16"
public_subnets_cidr = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets_cidr = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]
allowed_ip = "YOUR_IP_ADDRESS/32"  # Replace with your IP
instance_type = "t2.micro"
```
### 4. Initialize Terraform

```bash
terraform init
```

### 5. Review the Execution Plan

```bash
terraform plan
```

### 6. Apply the Configuration

```bash
terraform apply
```

When prompted, type `yes` to confirm.

## Accessing EC2 Instances

### Public Instance

```bash
ssh -i my-key-pair.pem ec2-user@<public-ip>
```

The public IP can be found in the Terraform outputs or AWS Console.

### Private Instance

First, SSH into the public instance, then from there:

```bash
ssh -i my-key-pair.pem ec2-user@<private-ip>
```

## Project Structure

```
.
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable definitions
├── outputs.tf        # Output definitions
├── terraform.tfvars  # Variable values
└── modules/
    ├── vpc/
    ├── nat/
    ├── route_tables/
    ├── security_groups/
    └── ec2/
```

## Modules

- **VPC**: Creates the VPC, subnets, and Internet Gateway
- **NAT**: Creates the NAT Gateway for private subnets
- **Route Tables**: Configures routing for public and private subnets
- **Security Groups**: Defines security rules for EC2 instances
- **EC2**: Launches EC2 instances in public and private subnets

## Clean Up

To destroy all resources created by Terraform:

```bash
terraform destroy
```

**Note**: This will delete all resources created by this project. Make sure you want to do this before confirming.

## Security Considerations

1. The `allowed_ip` variable should be restricted to your IP address or your organization's IP range
2. Consider using AWS Systems Manager Session Manager instead of SSH for production environments
3. Regularly update the Amazon Linux 2 AMI for security patches

## Troubleshooting

1. If `terraform apply` fails:
   - Check AWS credentials
   - Verify variable values in terraform.tfvars
   - Ensure your AWS account has proper permissions

2. If you can't SSH into instances:
   - Verify security group rules
   - Check if the key pair is correct
   - Ensure you're using the right username (ec2-user for Amazon Linux 2)

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request