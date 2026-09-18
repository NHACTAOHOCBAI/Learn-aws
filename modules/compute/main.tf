resource "aws_instance" "udemy-instance" {
  ami                    = var.image_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.ec2_security_group_ids
  tags = {
    Name = "Udemy name"
  }
}
resource "aws_eip" "udemy-eip" {
  domain   = "vpc"
  instance = aws_instance.udemy-instance.id
}

