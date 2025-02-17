variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-2"
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
  default     = "example-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
