resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_assoc" {
  count = length(var.public_subnets)

  subnet_id      = var.public_subnets[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
}

resource "aws_route" "private_nat" {
  route_table_id         = aws_route_table.private.id
  nat_gateway_id         = var.nat_gateway_id
  destination_cidr_block = "0.0.0.0/0"
}