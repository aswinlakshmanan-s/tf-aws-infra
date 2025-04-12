variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
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
  default     = ""
}

variable "db_security_group_id" {
  description = "Security group ID for the RDS instance"
  type        = string
  default     = ""
}

variable "database_password" {
  description = "Password for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = ""
}

variable "s3_bucket_id" {
  description = "S3 bucket ID for storing profile pictures"
  type        = string
  default     = ""
}

variable "rds_endpoint" {
  description = "Endpoint for the RDS instance"
  type        = string
  default     = ""
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "load_balancer_sg_id" {
  description = "Security group ID for the load balancer"
  type        = string
  default     = ""
}

variable "vpc_id" {
  description = "VPC ID to create subnets in"
  type        = string
  default     = ""
}

variable "admin_cidr_blocks" {
  description = "CIDR blocks allowed for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
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
  default     = "postgres16"
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
  default     = "16"
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


# New variables for DNS and key pair
variable "domain_name" {
  description = "Root domain name for DNS records (e.g. aswinlakshmanan.me)"
  type        = string
  default     = "aswinlakshmanan.me"
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "my-app-key"
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group"
  type        = string
  default     = "csye6225_asg"
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling Group"
  type        = number
  default     = 5
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "health_check_type" {
  description = "The type of health check to use (ELB or EC2)"
  type        = string
  default     = "ELB"
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

variable "default_cooldown" {
  description = "Default cooldown period (in seconds) for the ASG"
  type        = number
  default     = 60
}

variable "asg_tag_value" {
  description = "Tag value for the AutoScalingGroup tag"
  type        = string
  default     = "csye6225_asg"
}

variable "scale_up_policy_name" {
  description = "Name of the scale-up policy"
  type        = string
  default     = "scale-up-policy"
}

variable "scale_up_adjustment" {
  description = "Scaling adjustment for scale-up"
  type        = number
  default     = 1
}

variable "scale_up_cooldown" {
  description = "Cooldown for the scale-up policy in seconds"
  type        = number
  default     = 60
}

variable "scale_up_adjustment_type" {
  description = "Adjustment type for scale-up (ChangeInCapacity)"
  type        = string
  default     = "ChangeInCapacity"
}

variable "cpu_high_alarm_name" {
  description = "CloudWatch alarm name for high CPU utilization"
  type        = string
  default     = "cpu_high_alarm"
}

variable "cpu_high_comparison_operator" {
  description = "Comparison operator for high CPU alarm"
  type        = string
  default     = "GreaterThanThreshold"
}

variable "cpu_high_evaluation_periods" {
  description = "Evaluation periods for the high CPU alarm"
  type        = number
  default     = 1
}

variable "cpu_high_metric_name" {
  description = "Metric name for the high CPU alarm"
  type        = string
  default     = "CPUUtilization"
}

variable "cpu_high_namespace" {
  description = "Metric namespace for the high CPU alarm"
  type        = string
  default     = "AWS/EC2"
}

variable "cpu_high_period" {
  description = "Period (in seconds) for the high CPU alarm"
  type        = number
  default     = 60
}

variable "cpu_high_statistic" {
  description = "Statistic for the high CPU alarm"
  type        = string
  default     = "Average"
}

variable "cpu_high_threshold" {
  description = "CPU threshold for scaling up"
  type        = number
  default     = 8
}

variable "cpu_high_alarm_description" {
  description = "Description for the high CPU alarm"
  type        = string
  default     = "Scale up if CPU utilization > 8%"
}

variable "scale_down_policy_name" {
  description = "Name of the scale-down policy"
  type        = string
  default     = "scale-down-policy"
}

variable "scale_down_adjustment" {
  description = "Scaling adjustment for scale-down"
  type        = number
  default     = -1
}

variable "scale_down_cooldown" {
  description = "Cooldown for the scale-down policy in seconds"
  type        = number
  default     = 60
}

variable "scale_down_adjustment_type" {
  description = "Adjustment type for scale-down (ChangeInCapacity)"
  type        = string
  default     = "ChangeInCapacity"
}

variable "cpu_low_alarm_name" {
  description = "CloudWatch alarm name for low CPU utilization"
  type        = string
  default     = "cpu_low_alarm"
}

variable "cpu_low_comparison_operator" {
  description = "Comparison operator for low CPU alarm"
  type        = string
  default     = "LessThanThreshold"
}

variable "cpu_low_evaluation_periods" {
  description = "Evaluation periods for the low CPU alarm"
  type        = number
  default     = 1
}

variable "cpu_low_metric_name" {
  description = "Metric name for the low CPU alarm"
  type        = string
  default     = "CPUUtilization"
}

variable "cpu_low_namespace" {
  description = "Metric namespace for the low CPU alarm"
  type        = string
  default     = "AWS/EC2"
}

variable "cpu_low_period" {
  description = "Period (in seconds) for the low CPU alarm"
  type        = number
  default     = 60
}

variable "cpu_low_statistic" {
  description = "Statistic for the low CPU alarm"
  type        = string
  default     = "Average"
}

variable "cpu_low_threshold" {
  description = "CPU threshold for scaling down"
  type        = number
  default     = 6
}

variable "cpu_low_alarm_description" {
  description = "Description for the low CPU alarm"
  type        = string
  default     = "Scale down if CPU utilization < 6%"
}

variable "device_name" {
  description = "Device name for the root volume"
  type        = string
  default     = "/dev/sda1"
}

variable "launch_template_prefix" {
  description = "Prefix for the launch template name"
  type        = string
  default     = "csye6225_asg"
}

variable "lb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
  default     = "app-lb"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal (true) or public (false)"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Type of the load balancer (e.g., application, network)"
  type        = string
  default     = "application"
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
  default     = "app-tg"
}

variable "tg_port" {
  description = "Port on which the target group forwards traffic"
  type        = number
  default     = 8080
}

variable "tg_protocol" {
  description = "Protocol for the target group (HTTP/HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "hc_healthy_threshold" {
  description = "Number of consecutive successful health checks before considering a target healthy"
  type        = number
  default     = 2
}

variable "hc_unhealthy_threshold" {
  description = "Number of consecutive failed health checks before considering a target unhealthy"
  type        = number
  default     = 2
}

variable "hc_timeout" {
  description = "Timeout (in seconds) for each health check"
  type        = number
  default     = 5
}

variable "hc_interval" {
  description = "Interval (in seconds) between health checks"
  type        = number
  default     = 30
}

variable "hc_matcher" {
  description = "The expected HTTP response code from the health check"
  type        = string
  default     = "200"
}

variable "hc_path" {
  description = "The path for the health check endpoint"
  type        = string
  default     = "/healthz"
}

variable "hc_protocol" {
  description = "Protocol used for the health check (HTTP/HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "listener_port" {
  description = "Port on which the ALB listens"
  type        = number
  default     = 443
}

variable "listener_protocol" {
  description = "Protocol used by the ALB listener"
  type        = string
  default     = "HTTPS"
}


variable "route53_zone_name_dev" {
  description = "The hosted zone name for the dev environment"
  type        = string
  default     = "dev.aswinlakshmanan.me"
}

variable "route53_zone_name_demo" {
  description = "The hosted zone name for the demo environment"
  type        = string
  default     = "demo.aswinlakshmanan.me"
}

variable "route53_record_type" {
  description = "DNS record type"
  type        = string
  default     = "A"
}

variable "route53_record_name" {
  description = "DNS record name. Leave empty for apex records"
  type        = string
  default     = ""
}

variable "launch_template_name" {
  description = "The fixed name for the EC2 launch template"
  type        = string
  default     = "csye6225-webapp-lt"
}

variable "certificate_acm_arn" {
  description = "ACM for Demo Env"
  type        = string
  default     = "arn:aws:acm:us-east-1:474668419602:certificate/df5bab86-4e42-4c1d-b947-6411855ed44d"
}


variable "rotation_period" {
  description = "KMS Rotation Period in days"
  type        = number
  default     = 90
}

variable "deletion_window" {
  description = "KMS key deletion window in days"
  type        = number
  default     = 7
}

variable "key_rotation_status" {
  description = "KMS key rotation"
  type        = bool
  default     = true

}
