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
  iam_instance_profile        = aws_iam_instance_profile.s3_access_profile.name # Attach IAM role for S3 access

  # User Data to configure the Node.js application with database credentials
  user_data = <<-EOF
              #!/bin/bash
              # Create a .env file for the Node.js application
              ENV_FILE="/opt/csye6225/webapp/.env"
              touch $ENV_FILE

              # Write database credentials to the .env file
              echo "DB_USER=${var.db_username}" >> $ENV_FILE
              echo "DB_PASS=${var.db_password}" >> $ENV_FILE
              echo "DB_HOST=${aws_db_instance.csye6225.endpoint}" >> $ENV_FILE
              echo "DB_NAME=${var.db_name}" >> $ENV_FILE
              echo "DB_PORT=${var.db_port}" >> $ENV_FILE
              echo "DB_DIALECT=${var.db_dialect}" >> $ENV_FILE
              echo "AWS_REGION=${var.aws_region}" >> $ENV_FILE  # Add AWS region for S3 access
              echo "AWS_BUCKET_NAME=${var.s3_bucket_name}" >> $ENV_FILE  # Add S3 bucket name

              # Set permissions for the .env file
              chmod 600 $ENV_FILE
              chown csye6225:csye6225 $ENV_FILE

              # Start the Node.js application
              cd /opt/csye6225/webapp
              npm install
              npm run start &
              EOF

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_name
  }
}
