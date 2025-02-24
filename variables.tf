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
}

variable "app_port" {
  description = "Port on which the web application listens"
  type        = number
  default     = 4000
}
