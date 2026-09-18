provider "aws" {
  region = var.region
}

resource "aws_key_pair" "udemy-keypair" {
  key_name   = "udemy-keypair"
  public_key = file("keypair/udemy-key.pub")
}

module "vpc" {
  source = "./modules/vpc"
}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
}

module "compute" {
  source                 = "./modules/compute"
  image_id               = var.amis[var.region]
  key_name               = aws_key_pair.udemy-keypair.key_name
  instance_type          = var.instance_type
  subnet_id              = module.vpc.public_subnet_id
  ec2_security_group_ids = [module.security.public_security_group_id]
}

