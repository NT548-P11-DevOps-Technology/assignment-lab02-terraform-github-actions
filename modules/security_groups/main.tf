# Security group module
resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = var.description
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name}-sg"
  }
}

# Ingress rules
resource "aws_vpc_security_group_ingress_rule" "ingress" {
  count             = length(var.ingress_rules)
  security_group_id = aws_security_group.this.id
  description       = var.ingress_rules[count.index].description
  from_port         = var.ingress_rules[count.index].from_port
  to_port           = var.ingress_rules[count.index].to_port
  ip_protocol       = var.ingress_rules[count.index].protocol

  # Conditional logic for CIDR or security group ID
  cidr_ipv4                    = (var.ingress_rules[count.index].ip != null) ? var.ingress_rules[count.index].ip : ""
  referenced_security_group_id = var.ingress_rules[count.index].security_group_id != null ? var.ingress_rules[count.index].security_group_id : ""
}

# Egress rules
resource "aws_vpc_security_group_egress_rule" "egress" {
  count             = length(var.egress_rules)
  security_group_id = aws_security_group.this.id
  description       = var.egress_rules[count.index].description
  from_port         = var.egress_rules[count.index].from_port
  to_port           = var.egress_rules[count.index].to_port
  ip_protocol       = var.egress_rules[count.index].protocol

  # Conditional logic for CIDR or security group ID
  cidr_ipv4                    = var.egress_rules[count.index].ip != null ? var.egress_rules[count.index].ip : ""
  referenced_security_group_id = var.egress_rules[count.index].security_group_id != null ? var.egress_rules[count.index].security_group_id : ""
}
