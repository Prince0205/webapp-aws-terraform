variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "key_name" {}
variable "public_key_path" {}
variable "private_key_path" {}

variable "aws_region" {
    description = "EC2 Region - us-east-1"
    default = "us-east-1"    # N. Virginia
    #efault = "eu-central-1"  # Frankfurt
}

variable "availability_zone" {
  description = "Availability zone for instances"
  default = "us-east-1a"   # N. Virginia
  #default = "eu-central-1a" # Frankfurt
}

variable "amis" {
	description = "AMIs by region"
	default = "ami-c998b6b2" # RedHat 14.04 LTS N. Virginia -> RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2
	#default = "ami-c425e4ab" # SUSE 12 Frankfurt -> suse-sles-12-sp2-v20161214-hvm-ssd-x86_64
	#default = "ami-b646bbd9" # AWS NAT instance Frankfurt -> amzn-ami-vpc-nat-hvm-2016.09.0.20160923-x86_64-ebs
}

variable "amis-nat" {
  description = "AMIs by region"
  default = "ami-c998b6b2" # RedHat 14.04 LTS N. Virginia -> RHEL-7.4_HVM_GA-20170808-x86_64-2-Hourly2-GP2
  #default = "ami-293a183f" # N. Virginia -> amzn-ami-vpc-nat-hvm-2017.03.1.20170617-x86_64-ebs
  #default = "ami-b646bbd9" # Frankfurt -> amzn-ami-vpc-nat-hvm-2016.09.0.20160923-x86_64-ebs
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

# add test