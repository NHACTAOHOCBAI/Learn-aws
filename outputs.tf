output "instance_ip_addr" {
  description = "Elastic IP address of the EC2 instance"
  value       = module.compute.elastic_ip
}

output "instance_public_ip" {
  description = "Initial Public IP address of the EC2 instance"
  value       = module.compute.instance_public_ip
}
