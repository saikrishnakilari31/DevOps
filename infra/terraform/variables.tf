variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project" {
  type    = string
  default = "pi-credit"
}

variable "env" {
  type    = string
  default = "staging"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.0.0/24","10.10.1.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.10.10.0/24","10.10.11.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "asg_min" { type = number, default = 1 }
variable "asg_max" { type = number, default = 3 }
variable "asg_desired" { type = number, default = 1 }

variable "key_pair_name" {
  type = string
  description = "SSH key pair for bastion (must exist in AWS)"
  default = ""
}

variable "db_allocated_storage" { type = number, default = 20 }
variable "db_instance_class" { type = string, default = "db.t3.micro" }
variable "db_name" { type = string, default = "appdb" }
variable "db_username" { type = string, default = "appuser" }
variable "db_password" { type = string, default = "" , sensitive = true }

variable "tags" {
  type = map(string)
  default = {
    Owner = "devops"
    Project = "pi-credit"
  }
}

variable "bastion_allowed_cidr" { type = string, default = "0.0.0.0/0" }
