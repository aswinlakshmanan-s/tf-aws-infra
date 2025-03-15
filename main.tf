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

# VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

# Public Subnets
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

# Private Subnets
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

# Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

# Public Route
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Public Route Table Association
resource "aws_route_table_association" "public_rt_association" {
  count          = length(local.public_subnets_cidrs)
  route_table_id = aws_route_table.public_rt.id
  subnet_id      = aws_subnet.public_subnets[count.index].id
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

# Private Route Table Association
resource "aws_route_table_association" "private_rt_association" {
  count          = length(local.private_subnets_cidrs)
  route_table_id = aws_route_table.private_rt.id
  subnet_id      = aws_subnet.private_subnets[count.index].id
}

# S3 Bucket
resource "aws_s3_bucket" "webapp_bucket" {
  bucket        = var.s3_bucket_name != "" ? var.s3_bucket_name : uuid()
  force_destroy = true

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  lifecycle_rule {
    id      = "transition-to-standard-ia"
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
  }

  tags = {
    Name = "webapp-bucket"
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-security-group"
  description = "Allow traffic from the application security group"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port       = 5432 # PostgreSQL port
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] # Allow traffic from app_sg
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-security-group"
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "pg_param_group" {
  name   = "csye6225-pg-param-group"
  family = "postgres13" # Adjust based on your PostgreSQL version

  parameter {
    name  = "log_statement"
    value = "all"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "private_subnet_group" {
  name       = "private-subnet-group"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "private-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "csye6225" {
  identifier             = "csye6225"
  engine                 = "postgres"
  engine_version         = "13.4" # Specify your PostgreSQL version
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.pg_param_group.name
  db_subnet_group_name   = aws_db_subnet_group.private_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true
}

# IAM Role for S3 Access
resource "aws_iam_role" "s3_access_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Policy for S3 Access
resource "aws_iam_role_policy" "s3_access_policy" {
  name = "s3-access-policy"
  role = aws_iam_role.s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.webapp_bucket.arn}/*"
      },
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = var.iam_instance_profile_name
  role = aws_iam_role.s3_access_role.name
}
