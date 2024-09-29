resource "aws_vpc" "optima" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.optima.id
  cidr_block = cidrsubnet(aws_vpc.optima.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count = var.private_subnet_count
  vpc_id = aws_vpc.optima.id
  cidr_block = cidrsubnet(aws_vpc.optima.cidr_block, 4, count.index + var.public_subnet_count)
  map_public_ip_on_launch = false
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.optima.id
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.optima.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_eip" "optima" {}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.optima.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.optima.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
}

resource "aws_route_table_association" "public" {
  count = var.public_subnet_count
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = var.private_subnet_count
  subnet_id = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
