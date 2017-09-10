variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}
# private key - jenkins.pub

variable "aws_region" {
    description = "EC2 Region - us-east-1"
    default = "us-east-1"
}

variable "amis" {
	description = "AMIs by region"
	default = "ami-c998b6b2" # RedHat 14.04 LTS
}


variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}


variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.1.0/24"
}