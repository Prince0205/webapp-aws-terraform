variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "aws_region" {
    description = "EC2 Region - us-east-1"
    #default = "us-east-1"    # N. Virginia
    default = "eu-central-1"  # Frankfurt
}

variable "availability_zone" {
  description = "Availability zone for instances"
  #default = "us-east-1b"   # N. Virginia
  default = "eu-central-1a" # Frankfurt
}

variable "amis" {
	description = "AMIs by region"
	#default = "ami-c998b6b2" # RedHat 14.04 LTS N. Virginia
	default = "ami-d74be5b8" # RedHat 14.04 LTS Frankfurt -> RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2
}

variable "amis-nat" {
  description = "AMIs by region"
  #default = "ami-293a183f" # N. Virginia -> Amazon Linux AMI 2017.03.0.20170401 x86_64 VPC NAT HVM EBS
  default = "ami-b646bbd9" # Frankfurt -> amzn-ami-vpc-nat-hvm-2016.09.0.20160923-x86_64-ebs
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