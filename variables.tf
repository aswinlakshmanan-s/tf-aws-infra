# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

# VPC Configuration
variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
  default     = "main-vpc"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "profile" {
  description = "AWS profile to use"
  type        = string
  default     = "dev"
}

variable "vpc_subnet_mask" {
  description = "Subnet mask for the VPC subnets"
  type        = number
  default     = 4
}

# EC2 Configuration
variable "custom_ami" {
  description = "The custom AMI ID built via Packer"
  type        = string
}

variable "app_port" {
  description = "Port on which the web application listens"
  type        = number
  default     = 8000
}

variable "app_sg_name" {
  description = "Name of the security group for the application"
  type        = string
  default     = "application-sg"
}

variable "app_sg_description" {
  description = "Description for the security group"
  type        = string
  default     = "Security group for EC2 instances hosting web applications"
}

variable "ssh_port" {
  description = "SSH port for admin access"
  type        = number
  default     = 22
}

variable "http_port" {
  description = "HTTP port"
  type        = number
  default     = 80
}

variable "https_port" {
  description = "HTTPS port"
  type        = number
  default     = 443
}

variable "allowed_cidr" {
  description = "CIDR blocks allowed for ingress traffic"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address with the instance"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "Disable API termination for the instance"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Size of the root volume (in GB)"
  type        = number
  default     = 25
}

variable "root_volume_type" {
  description = "Type of the root volume"
  type        = string
  default     = "gp2"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "webapp-instance"
}

# S3 Configuration
variable "s3_bucket_name" {
  description = "Name of the S3 bucket (UUID will be generated)"
  type        = string
  default     = "" # Leave empty to generate UUID
}

# RDS Configuration
variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "csye6225"
}

variable "db_port" {
  description = "Database port"
  type        = string
  default     = "5432" # Default port for PostgreSQL
}

variable "db_dialect" {
  description = "Database dialect"
  type        = string
  default     = "postgres" # Default dialect for PostgreSQL
}

# IAM Configuration
variable "iam_role_name" {
  description = "Name of the IAM role for S3 access"
  type        = string
  default     = "s3-access-role"
}

variable "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  type        = string
  default     = "s3-access-profile"
}
