output "instance_public_ip" {
  description = "Initial public IP of the EC2 instance"
  value       = aws_instance.udemy-instance.public_ip
}

output "instance_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.udemy-instance.private_ip
}

output "elastic_ip" {
  description = "Elastic IP address of the EC2 instance"
  value       = aws_eip.udemy-eip.public_ip
}
