resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Public Subnets
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-south-1b"
  map_public_ip_on_launch = true
}

# Private Subnets
resource "aws_subnet" "private_az1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "ap-south-1a"
}

resource "aws_subnet" "private_az2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "ap-south-1b"
}

# NAT Elastic IPs
resource "aws_eip" "nat1" {
  domain = "vpc"
}

resource "aws_eip" "nat2" {
  domain = "vpc"
}

# NAT Gateways
resource "aws_nat_gateway" "nat_az1" {
  allocation_id = aws_eip.nat1.id
  subnet_id     = aws_subnet.public_az1.id
}

resource "aws_nat_gateway" "nat_az2" {
  allocation_id = aws_eip.nat2.id
  subnet_id     = aws_subnet.public_az2.id
}

# Route Tables

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Associate Public Subnets
resource "aws_route_table_association" "pub_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pub_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# Private Route Table AZ1
resource "aws_route_table" "private_rt_az1" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_az1" {
  route_table_id         = aws_route_table.private_rt_az1.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_az1.id
}

resource "aws_route_table_association" "priv_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_rt_az1.id
}

# Private Route Table AZ2
resource "aws_route_table" "private_rt_az2" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_az2" {
  route_table_id         = aws_route_table.private_rt_az2.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_az2.id
}

resource "aws_route_table_association" "priv_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_rt_az2.id
}
