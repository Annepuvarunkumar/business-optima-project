output "vpc_id" {
  value = aws_vpc.optima.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}
