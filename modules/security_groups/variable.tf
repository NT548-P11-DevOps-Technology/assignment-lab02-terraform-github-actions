variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    description       = optional(string)
    from_port         = number
    to_port           = number
    protocol          = optional(string, "tcp")
    ip                = optional(string)
    security_group_id = optional(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    description       = optional(string)
    from_port         = optional(number, 0)
    to_port           = optional(number, 0)
    protocol          = optional(string, "-1")
    ip                = optional(string)
    security_group_id = optional(string)
  }))
  default = []
}
