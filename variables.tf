# VPC Settings
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR Block for VPC"
}
variable "primary_subnet_cidr_block" {
  type        = string
  description = "CIDR Block for Primary Subnet"
}
variable "secondary_subnet_cidr_block" {
  type        = string
  description = "CIDR Block for Secondary Subnet"
}

# S3 Settings
variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

# WAF Settings
variable "allowed_ips" {
  type        = list
  description = "Allowed IP Addresses for ECS Service"
}

# ECS Settings 
variable "ecs_image" {
  type        = string
  description = "ECS Task container image"
}
 