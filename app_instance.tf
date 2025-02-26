# Application Security Group for the web application
resource "aws_security_group" "app_sg" {
  name        = var.app_sg_name
  description = var.app_sg_description
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH (admin use only)"
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  ingress {
    description = "Allow HTTP"
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  ingress {
    description = "Allow Web Application Port"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr
  }

  # No ingress rule for database ports (e.g., 3306 or 5432) to keep them isolated

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr
  }

  tags = {
    Name = var.app_sg_name
  }
}

# EC2 Instance using the custom AMI
resource "aws_instance" "app_instance" {
  ami                         = var.custom_ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnets[0].id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = var.associate_public_ip_address
  disable_api_termination     = var.disable_api_termination

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}
