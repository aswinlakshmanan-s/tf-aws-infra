// Load Balancer Security Group – allows HTTP/HTTPS from anywhere
resource "aws_security_group" "lb_sg" {
  name        = "lb-security-group"
  description = "Security group for the load balancer to access the web application"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS traffic"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lb-sg"
  }
}

// Updated Application Security Group for the web application instances
resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = aws_vpc.main_vpc.id

  // Allow SSH only from the Load Balancer security group
  ingress {
    description     = "Allow SSH from load balancer security group"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  // Allow application traffic (e.g. HTTP on app_port) only from the Load Balancer security group
  ingress {
    description     = "Allow application traffic from load balancer security group"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  // (Optional) Remove previous rules that allowed public access

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = var.app_sg_name
    Environment = "Production"
    Project     = "WebApp"
  }
}

resource "aws_security_group" "db_sg" {
  name        = "db-sg"
  description = "Security group for RDS instances"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description     = "Allow database traffic from the application security group"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description     = "Allow all outbound traffic"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  tags = {
    Name = "db-sg"
  }
}
