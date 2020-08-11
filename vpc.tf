resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-vpc"
  }
}

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id
}

/*
  Public Subnet
*/
resource "aws_subnet" "public" {
  count  = length(var.public_subnet_cidr)
  vpc_id = aws_vpc.default.id

  cidr_block = var.public_subnet_cidr[count.index]

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name = "Public Subnet"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat_eip" {
  count = var.private_workers == false ? 0 : 1
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.private_workers == false ? 0 : 1
  allocation_id = aws_eip.nat_eip[0].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
}

/*
  Private Subnet
*/
resource "aws_subnet" "private" {
  count  = length(var.private_subnet_cidr)
  vpc_id = aws_vpc.default.id

  cidr_block = var.private_subnet_cidr[count.index]

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route_table" "private" {
  count  = var.private_workers == false ? 0 : 1
  vpc_id = aws_vpc.default.id

  tags = {
    Name = "Private Subnet"
  }
}

resource "aws_route" "private_nat_gateway_route" {
  count                  = var.private_workers == false ? 0 : 1
  route_table_id         = aws_route_table.private[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw[0].id
}

resource "aws_route_table_association" "private-a" {
  count          = var.private_workers == false ? 0 : length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private[0].id
}

