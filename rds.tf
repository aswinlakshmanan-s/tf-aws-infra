# Generate a strong password for the RDS instance
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# RDS Parameter Group
resource "aws_db_parameter_group" "db_parameter_group" {
  name        = "csye6225-db-parameter-group"
  family      = "postgres12" # Use "mysql5.7" for MySQL or "mariadb10.5" for MariaDB
  description = "Custom parameter group for csye6225"

  parameter {
    name  = "rds.force_ssl"
    value = "1" # Enforce SSL for secure connections
  }

  tags = {
    Name        = "csye6225-db-parameter-group"
    Environment = "Production"
  }
}

# RDS Subnet Group
resource "aws_db_subnet_group" "private_subnets" {
  name        = "rds-private-subnet-group"
  description = "Private subnet group for RDS"
  subnet_ids  = aws_subnet.private_subnets[*].id

  tags = {
    Name = "Private Subnets for RDS"
  }
}

# RDS Instance
resource "aws_db_instance" "csye6225_rds" {
  allocated_storage      = 20
  engine                 = "postgres"    # Use "mysql" for MySQL or "mariadb" for MariaDB
  engine_version         = "12"          # Use "5.7" for MySQL or "10.5" for MariaDB
  instance_class         = "db.t3.micro" # Cheapest instance class
  identifier             = "csye6225"
  username               = "csye6225"
  password               = random_password.db_password.result
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  db_subnet_group_name   = aws_db_subnet_group.private_subnets.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = true

  tags = {
    Name = "csye6225-db-instance"
  }
}
