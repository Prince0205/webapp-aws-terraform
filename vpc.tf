resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    tags { Name = "webapp-aws-vpc" }
}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.default.id}"
	tags {Name = "InternetGateway"}
}

/*
  NAT Instance
 */
 
resource "aws_security_group" "nat" {
    name = "vpc_nat"
    description = "Allow traffic to pass from the private subnet to the internet"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
	}
	ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    egress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags { Name = "NATSG" }
}

resource "aws_instance" "nat" {
    ami = "${var.amis-nat}"
	# this is a special ami preconfigured to do NAT
	# Amazon Linux AMI 2017.03.0.20170401 x86_64 VPC NAT HVM EBS
    availability_zone = "${var.availability_zone}"
	private_ip = "10.0.0.10"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.nat.id}"]
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    associate_public_ip_address = true
    source_dest_check = false

    # Create folders
    provisioner "remote-exec" {
      inline = [
        "mkdir script",
        "mkdir ansible",
        "echo 'Create folders...DONE' "
      ]
      connection {
        type		= "ssh"
        user		= "ec2-user"
        private_key	= "${file(var.private_key_path)}"
        #agent		= true
      }
    }

    # local script/ -> remote /$HOME/script/
	provisioner "file" {
		source      = "script/"
		destination = "$HOME/script"
		connection {
			type		= "ssh"
			user		= "ec2-user"
			private_key	= "${file(var.private_key_path)}"
		}
	}

    # ansible/ -> $HOME/ansible
    provisioner "file" {
      source      = "ansible/"
      destination = "$HOME/ansible"
      connection {
        type		= "ssh"
        user		= "ec2-user"
        private_key	= "${file(var.private_key_path)}"
      }
    }

    # .ssh/jenkins* -> $HOME/.ssh/
    provisioner "file" {
      source = "/home/ec2-user/.ssh/jenkins"
      destination = "/home/ec2-user/.ssh/jenkins"
      connection {
        type = "ssh"
        user = "ec2-user"
        private_key = "${file(var.private_key_path)}"
      }
    }

  

    provisioner "remote-exec" {
		inline = [
            "ls -lart /home/ec2-user/.ssh/",
            "pwd",
			"echo '[Change permission for exucution]'",
			"sudo chmod 777 /$HOME/script/*",
			"echo '[Permission changed succsefully on all files /home/ec2-user/script/]' ",
			"ls -lart /$HOME/script/",
			"ls -lart /$HOME/ansible/",
			"echo '[Start provisining...]'",
			"cd /$HOME/script",
			"./install_nat.sh"
		]
		
		connection {
			type		= "ssh"
			user		= "ec2-user"
			private_key	= "${file(var.private_key_path)}"
			#agent		= true
		}
	}
    tags {Name = "VPC NAT"}
}

resource "aws_eip" "nat" {
    instance = "${aws_instance.nat.id}"
    vpc = true
}

# test

/*
  Public Subnet
*/


resource "aws_subnet" "us-east-1-public" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.public_subnet_cidr}"
    availability_zone = "${var.availability_zone}"

    tags {Name = "Public Subnet"}
}

resource "aws_route_table" "us-east-1-public" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }

    tags {Name = "Public Subnet"}
}

resource "aws_route_table_association" "us-east-1-public" {
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    route_table_id = "${aws_route_table.us-east-1-public.id}"
}

/*
  Private Subnet
*/

resource "aws_subnet" "us-east-1-private" {
    vpc_id = "${aws_vpc.default.id}"

    cidr_block = "${var.private_subnet_cidr}"
    availability_zone = "${var.availability_zone}"

    tags {Name = "Private Subnet"}
}

resource "aws_route_table" "us-east-1-private" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.nat.id}"
    }

    tags {Name = "Private Subnet"}
}

resource "aws_route_table_association" "us-east-1-private" {
    subnet_id = "${aws_subnet.us-east-1-private.id}"
    route_table_id = "${aws_route_table.us-east-1-private.id}"
}