

resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr

  tags = {
    "Name" = "custom-VPC"
  }
}

locals {
  vpc_cidr = "10.0.0.0/16"
  public_cidr        = ["10.0.0.0/24", "10.0.1.0/24"]
  private_cidr        = ["10.0.2.0/24", "10.0.3.0/24"]

  availability_zones = ["ap-south-1a", "ap-south-1b"]
}

# Public subnets 

resource "aws_subnet" "public" {

  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
  tags = {
    "Name" = "public${count.index+1}"
  }
}


# Private subnets

resource "aws_subnet" "private" {
  count = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
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
  count = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}






resource "aws_eip" "nat" {
  count = 2
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  count = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
}



# Private Route table


resource "aws_route_table" "private" {
  count = 2
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
  count = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

