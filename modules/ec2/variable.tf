variable "name" {
  description = "Name of the public EC2 instances"
  type        = string
}

variable "ami" {
  description = "AMI ID for the EC2 instances"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  type        = string
}

variable "public_subnets_id" {
  description = "Subnet ID for the public EC2 instances"
  type        = list(string)
}

variable "private_subnets_id" {
  description = "Subnet ID for the private EC2 instances"
  type        = list(string)
}

variable "public_sgs_id" {
  description = "Security Group ID for the public EC2 instances"
  type        = list(string)
}

variable "private_sgs_id" {
  description = "Security Group ID for the private EC2 instances"
  type        = list(string)
}

variable "public_instance_count" {
  description = "Number of public EC2 instances"
  type        = number
}

variable "private_instance_count" {
  description = "Number of private EC2 instances"
  type        = number
}

variable "key_name" {
  description = "Key pair name for the EC2 instances"
  type        = string
}
