resource "aws_vpc" "optima" {
  cidr_block = var.cidr_block  # Modify this as needed
}

resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id = aws_vpc.optima.id
  cidr_block = cidrsubnet(aws_vpc.optima.cidr_block, 4, count.index)
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.optima.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.optima.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.public[*].id[count.index]
  route_table_id = aws_route_table.public.id
}
