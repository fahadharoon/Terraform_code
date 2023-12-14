variable "ami" {
  type    = string
  default = "ami-0fc5d935ebf8bc3bc" # Amazon Linux 2 AMI (HVM), SSD Volume Type
}

variable "instance_type" {
  type    = string
  default = "t2.micro" # Default instance type
}

variable "keyname" {
  default = "ecs_key"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "default region"
}

variable "az1" {
  type        = string
  default     = "us-east-1a"
  description = "default region"
}

variable "az2" {
  type        = string
  default     = "us-east-1b"
  description = "default region"
}

variable "vpc_cidr" {
  type        = string
  default     = "15.0.0.0/16"
  description = "default vpc_cidr_block"
}

variable "pub_sub1_cidr_block" {
  type    = string
  default = "15.0.1.0/24"
}

variable "pub_sub2_cidr_block" {
  type    = string
  default = "15.0.2.0/24"
}

variable "sg_name" {
  type    = string
  default = "alb_sg"
}

variable "sg_tagname" {
  type    = string
  default = "SG for ALB"
}