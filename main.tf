resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    "Name" = "custom-VPC"
  }
}


# Public subnets 

resource "aws_subnet" "public" {

  count = length(var.public_cidr)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name" = "public${count.index+1}"
  }
}


# Private subnets

resource "aws_subnet" "private" {
  count = length(var.private_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name" = "private${count.index+1}"
  }
}



# Internet Gateway

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

}


# Route  Table 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    "Name" = "public-route-table"
  }
}

# Route Association 

resource "aws_route_table_association" "public" {
  count = length(var.public_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}






resource "aws_eip" "nat" {
  count = length(var.public_cidr)
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = length(var.public_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}



# Private Route table


resource "aws_route_table" "private" {
  count = length(var.private_cidr)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    "Name" = "private-route-table-${count.index}"
  }
}

# Route Association 

resource "aws_route_table_association" "private" {
  count = length(var.private_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

