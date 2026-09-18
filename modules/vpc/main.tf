resource "aws_vpc" "udemy_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "udemy-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.udemy_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true

  tags = {
    Name = "udemy-public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.udemy_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false

  tags = {
    Name = "udemy-private-subnet"
  }
}

resource "aws_internet_gateway" "udemy_igw" {
  vpc_id = aws_vpc.udemy_vpc.id

  tags = {
    Name = "udemy-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.udemy_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.udemy_igw.id
  }

  tags = {
    Name = "udemy-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.udemy_igw]

  tags = {
    Name = "udemy-nat-eip"
  }
}

# NAT Gateway (placed in Public Subnet)
resource "aws_nat_gateway" "udemy_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "udemy-nat-gw"
  }

  depends_on = [aws_internet_gateway.udemy_igw]
}

# Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.udemy_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.udemy_nat.id
  }

  tags = {
    Name = "udemy-private-rt"
  }
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

