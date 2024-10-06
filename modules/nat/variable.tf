# modules/nat/variables.tf

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "public_subnet_id" {
  description = "ID of the public subnet where NAT Gateway will be created"
  type        = string
}