# Application Security Group for the web application
resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = aws_vpc.main_vpc.id

  # Allow SSH access from a specific IP range (e.g., your office IP or bastion host)
  ingress {
    description = "Allow SSH (admin use only)"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.admin_cidr_blocks # Restrict to specific IPs
  }

  # Allow HTTPS traffic from the internet
  ingress {
    description = "Allow HTTPS"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  # Allow traffic on the application port (e.g., 8000)
  ingress {
    description = "Allow Web Application Port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  # Allow all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr
  }

  tags = {
    Name        = var.app_sg_name
    Environment = "Production"
    Project     = "WebApp"
  }
}

# Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow inbound traffic on the database port (e.g., 5432 for PostgreSQL or 3306 for MySQL/MariaDB)
  ingress {
    description     = "Allow database traffic from the application security group"
    from_port       = 5432 # Change to 3306 for MySQL/MariaDB
    to_port         = 5432 # Change to 3306 for MySQL/MariaDB
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id] # Allow traffic only from the application security group
  }

  # Allow all outbound traffic (optional, adjust as needed)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}
