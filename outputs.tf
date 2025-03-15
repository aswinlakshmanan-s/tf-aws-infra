# EC2 Instance Public IP
output "instance_public_ip" {
  description = "Public IP of the launched web application instance"
  value       = aws_instance.app_instance.public_ip
}

# S3 Bucket Name
output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.webapp_bucket.bucket
}

# RDS Endpoint
output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.csye6225.endpoint
}

# VPC ID
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

# Public Subnet IDs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

# Private Subnet IDs
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

# Application Security Group ID
output "app_sg_id" {
  description = "ID of the application security group"
  value       = aws_security_group.app_sg.id
}

# Database Security Group ID
output "db_sg_id" {
  description = "ID of the database security group"
  value       = aws_security_group.db_sg.id
}

# IAM Role Name
output "iam_role_name" {
  description = "Name of the IAM role for S3 access"
  value       = aws_iam_role.s3_access_role.name
}

# IAM Instance Profile Name
output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.s3_access_profile.name
}
