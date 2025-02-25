data "aws_availability_zones" "available" {
  state = "available"
}

locals {

  public_subnets_cidrs = [
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 0),
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 1),
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 2)
  ]

  private_subnets_cidrs = [
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 3),
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 4),
    cidrsubnet(var.vpc_cidr, var.vpc_subnet_mask, 5)
  ]
}

resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.bad

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_subnet" "public_subnets" {
  count                   = length(local.public_subnets_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = local.public_subnets_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.vpc_name}-public-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(local.private_subnets_cidrs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = local.private_subnets_cidrs[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.vpc_name}-private-${count.index}"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(local.public_subnets_cidrs)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = length(local.private_subnets_cidrs)
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}
