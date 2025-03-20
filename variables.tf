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

# Database Parameter Group
variable "db_parameter_group_name" {
  description = "Name for the RDS parameter group"
  type        = string
  default     = "csye6225-db-parameter-group"
}

variable "db_family" {
  description = "Database engine family (PostgreSQL, MySQL, or MariaDB)"
  type        = string
  default     = "postgres12"
}

variable "db_parameter_group_description" {
  description = "Description for the RDS parameter group"
  type        = string
  default     = "Custom parameter group for csye6225"
}

# Database Subnet Group
variable "db_subnet_group_name" {
  description = "Name for the RDS subnet group"
  type        = string
  default     = "rds-private-subnet-group"
}

variable "db_subnet_group_description" {
  description = "Description for the RDS subnet group"
  type        = string
  default     = "Private subnet group for RDS"
}

# RDS Instance
variable "db_allocated_storage" {
  description = "Allocated storage for the RDS instance (in GB)"
  type        = number
  default     = 20
}

variable "db_engine" {
  description = "Database engine (postgres, mysql, mariadb)"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "12"
}

variable "db_instance_class" {
  description = "Instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "db_identifier" {
  description = "Identifier for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "csye6225"
}

variable "db_publicly_accessible" {
  description = "Whether the RDS instance should be publicly accessible"
  type        = bool
  default     = false
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot on RDS deletion"
  type        = bool
  default     = true
}

variable "db_multi_az" {
  description = "Multi-AZ deployment (set to false for single AZ)"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Database name inside RDS"
  type        = string
  default     = "csye6225"
}

variable "environment" {
  description = "environment for running"
  type        = string
  default     = "production"
}

# S3 Bucket Configuration
variable "s3_bucket_prefix" {
  description = "Prefix for S3 bucket name"
  type        = string
  default     = "profile-pic-bucket"
}

variable "s3_bucket_name" {
  description = "Name tag for S3 bucket"
  type        = string
  default     = "profile-pic-bucket"
}

variable "s3_force_destroy" {
  description = "Allow Terraform to delete bucket even if it contains objects"
  type        = bool
  default     = true
}

# S3 Public Access Block
variable "s3_block_public_acls" {
  description = "Block public ACLs for S3 bucket"
  type        = bool
  default     = true
}

variable "s3_block_public_policy" {
  description = "Block public policy for S3 bucket"
  type        = bool
  default     = true
}

variable "s3_ignore_public_acls" {
  description = "Ignore public ACLs for S3 bucket"
  type        = bool
  default     = true
}

variable "s3_restrict_public_buckets" {
  description = "Restrict public bucket access"
  type        = bool
  default     = true
}

# S3 Encryption
variable "s3_encryption_algorithm" {
  description = "Encryption algorithm for S3 bucket"
  type        = string
  default     = "AES256"
}

# S3 Lifecycle Policies
variable "s3_lifecycle_rule_id" {
  description = "ID for the lifecycle rule"
  type        = string
  default     = "transition-to-standard-ia"
}

variable "s3_lifecycle_status" {
  description = "Enable or disable lifecycle rule"
  type        = string
  default     = "Enabled"
}

variable "s3_transition_days" {
  description = "Number of days before transitioning to STANDARD_IA storage class"
  type        = number
  default     = 30
}

variable "s3_transition_storage_class" {
  description = "Storage class for transitioned objects"
  type        = string
  default     = "STANDARD_IA"
}

variable "s3_expiration_days" {
  description = "Number of days before expiring objects"
  type        = number
  default     = 365
}

# IAM Role for S3
variable "s3_iam_role_name" {
  description = "IAM Role name for accessing S3 bucket"
  type        = string
  default     = "s3-access-role"
}

# S3 Bucket Policies
variable "s3_allowed_actions" {
  description = "Allowed S3 actions for IAM role"
  type        = list(string)
  default     = ["s3:*"]
}

variable "s3_denied_actions" {
  description = "Denied S3 actions for unauthorized access"
  type        = list(string)
  default     = ["s3:*"]
}

variable "database_name" {
  description = "database name"
  type        = string
  default     = "postgres"
}

variable "database_user" {
  description = "database user"
  type        = string
  default     = "csye6225"
}
