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
git clone https://github.com/NT548-P11-DevOps-Technology/assignment-lab01-terraform.git aws-terraform-infrastructure
cd aws-terraform-infrastructure/workflows/lab1
```

### 2. Configure Variables

Create a `terraform.tfvars` file:

```hcl
aws_region      = "us-east-1"
aws_profile     = "<your_aws_cli_profile>"
aws_environment = "dev"
aws_project     = "lab1"
aws_owner       = "devops-team"

aws_vpc_config = {
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
```
### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the Execution Plan

```bash
terraform plan
```

### 5. Apply the Configuration

```bash
terraform apply
```
When prompted, type `yes` to confirm.

### 6. Show the Outputs

```bash
terraform output
```

## Accessing EC2 Instances

### Add new key to ssh agent

```bash
ssh-add ./lab1-key.pem
```

### Public Instance

```bash
ssh ubuntu@<public-ip>
```

The public IP can be found in the Terraform outputs or AWS Console.

### Private Instance

SSH into the private instance via public instane

```bash
ssh -J ubuntu@<public-ip> ubuntu@<private-ip>
```

## Project Structure

```
.
├── modules
│   ├── keypair
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variable.tf
│   ├── security_groups
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variable.tf
│   └── vpc
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── workflows
│   ├── lab1
│   │   ├── .terraform.lock.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tf
│   │   ├── terraform.tfvars
│   │   └── varibles.tf
│   └── setup_backend
├── .gitignore
└── README.md
```

## Modules

- **EC2**: Launches EC2 instances in public and private subnets
- **keypair** Create SSH key for access EC2 instances
- **Security Groups**: Defines security rules for EC2 instances
- **VPC**: Creates the VPC, subnets, Internet Gateway, NAT Gateway for private subnets and Route tables for public and private subnets

## Clean Up

To destroy all resources created by Terraform:

```bash
terraform destroy
```

**Note**: This will delete all resources created by this project. Make sure you want to do this before confirming.

## Troubleshooting

1. If `terraform apply` fails:
   - Check AWS credentials, make sure you specify correctly aws cli profile
   - Verify variable values in terraform.tfvars
   - Ensure your AWS account has proper permissions

2. If you can't SSH into instances:
   - Check if the ssh agent is active
   - Check if the key pair is correct

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request