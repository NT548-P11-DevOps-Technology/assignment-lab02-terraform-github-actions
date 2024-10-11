# Output for Public EC2 Instances
output "public_instance_ips" {
  description = "Public IP addresses of the public EC2 instances"
  value = {
    for i in aws_instance.public_instances :
    i.id => {
      name       = i.tags["Name"]
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }
  }
}

# Output for Private EC2 Instances
output "private_instance_ips" {
  description = "Private IP addresses of the private EC2 instances"
  value = {
    for i in aws_instance.private_instances :
    i.id => {
      name       = i.tags["Name"]
      private_ip = i.private_ip
    }
  }
}
