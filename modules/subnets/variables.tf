variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string) 
}
