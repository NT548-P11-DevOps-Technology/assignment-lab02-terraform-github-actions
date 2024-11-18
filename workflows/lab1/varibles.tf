variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_environment" {
  description = "Environment"
  type        = string
}

variable "aws_project" {
  description = "Project"
  type        = string
}

variable "aws_owner" {
  description = "Owner"
  type        = string
}

variable "aws_vpc_config" {
  description = "VPC configuration"
  type = object({
    cidr_block                   = string,
    enable_dns_support           = bool,
    enable_dns_hostnames         = bool,
    public_subnets_cidr          = list(string),
    private_subnets_cidr         = list(string),
    number_of_availability_zones = number,
    enable_nat_gateway           = bool
  })
}

variable "aws_public_instance_count" {
  description = "Number of public instances"
  type        = number
}

variable "aws_private_instance_count" {
  description = "Number of private instances"
  type        = number
}

variable "aws_instance_type" {
  description = "Instance type"
  type        = string
}

variable "aws_key_name" {
  description = "Key pair name"
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS access key"
  type        = string
}
variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS secret key"
  type        = string
}
variable "AWS_SESSION_TOKEN" {
  description = "AWS session token"
  type        = string
}