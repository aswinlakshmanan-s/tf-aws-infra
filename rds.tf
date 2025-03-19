# Generate a strong password for the RDS instance
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# RDS Parameter Group
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = var.db_parameter_group_name
  family      = var.db_family
  description = var.db_parameter_group_description

  parameter {
    name  = "rds.force_ssl"
    value = "1" # Enforce SSL for secure connections
  }

  tags = {
    Name        = var.db_parameter_group_name
    Environment = var.environment
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "private_subnets" {
  name        = var.db_subnet_group_name
  description = var.db_subnet_group_description
  subnet_ids  = aws_subnet.private_subnets[*].id

  tags = {
    Name = var.db_subnet_group_name
  }
}

# RDS Instance
resource "aws_db_instance" "csye6225_rds" {
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  identifier             = var.db_identifier
  username               = var.db_username
  password               = random_password.db_password.result
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  db_subnet_group_name   = aws_db_subnet_group.private_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = var.db_publicly_accessible
  skip_final_snapshot    = var.db_skip_final_snapshot
  multi_az               = var.db_multi_az

  tags = {
    Name = var.db_identifier
  }
}
