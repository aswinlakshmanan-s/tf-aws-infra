variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

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

variable "custom_ami" {
  description = "The custom AMI ID built via Packer"
  type        = string
  default     = "ami-0e39e9071fd40589a" # Replace with your AMI ID
}

variable "app_port" {
  description = "Port on which the web application listens"
  type        = number
  default     = 8080
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

variable "security_group_id" {
  description = "Security group ID for the EC2 instance"
  type        = string
  default     = "" # Will be dynamically assigned
}

variable "db_security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
  default     = "" # Will be dynamically assigned
}

variable "database_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "" # Will be dynamically generated
}

variable "s3_bucket_id" {
  description = "S3 bucket ID for storing profile pictures"
  type        = string
  default     = "" # Will be dynamically generated
}

variable "rds_endpoint" {
  description = "Endpoint for the RDS instance"
  type        = string
  default     = "" # Will be dynamically assigned
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = [] # Will be dynamically assigned
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = [] # Will be dynamically assigned
}

variable "load_balancer_sg_id" {
  description = "Security group ID for the load balancer"
  type        = string
  default     = "" # Will be dynamically assigned
}

variable "vpc_id" {
  description = "VPC ID to create subnets in"
  type        = string
  default     = "" # Will be dynamically assigned
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"] # Replace with your office IP or bastion host IP
}
