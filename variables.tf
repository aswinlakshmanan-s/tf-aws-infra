variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name for the VPC"
  default     = "main-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}
variable "profile" {
  description = "choose AWS Profile"
  type        = string
  default     = "dev"
}

variable "vpc_subnet_mask" {
  description = "subnet mask for accomodating all subnet types"
  type        = number
  default     = 4
}
