variable "region" {
  default = "ap-south-1"
}

variable "project_name" {
  default = "secure-vpc"
}
variable "igw_id" {
  description = "VPC ID"
  type        = string
}

variable "nat_id" {
  description = "VPC ID"
  type        = string
}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}