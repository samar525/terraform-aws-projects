resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/16"

  tags = {
    Name = "My-VPC-Project"
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.4.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "public-subnet2"
  }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "private-subnet1"
  }
}

resource "aws_subnet" "private-subnet2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.2.0/24"
  availability_zone = "us-east-1d"

  tags = {
    Name = "private-subnet2"
  }
}
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-project-igw"
  }
}
resource "aws_eip" "eip" {
  domain   = "vpc"

  tags = {
    Name = "My-Project-Eip"
}
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    Name = "my-project-NAT-gw"
  }
}
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
tags = {
  Name = "Public-Route-Table"
}
}
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }
tags = {
  Name = "Private-Route-Table"
 }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private-route-table.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private-route-table.id
}

