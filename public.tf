/*
  Web Servers
*/

resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    egress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
	egress { # SSH
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
	

    vpc_id = "${aws_vpc.default.id}"

    tags {Name = "WebServerSG"}
}

resource "aws_instance" "web-1" {
    ami = "${var.amis}"
    availability_zone = "us-east-1b"
	private_ip = "10.0.0.100"
    instance_type = "t2.micro"
    key_name = "${var.key_name}"
    vpc_security_group_ids = ["${aws_security_group.web.id}"]
    subnet_id = "${aws_subnet.us-east-1-public.id}"
    source_dest_check = false
    associate_public_ip_address = true
	
	provisioner "file" {
		source      = "/home/ec2-user/.ssh/"
		destination = "/home/ec2-user/.ssh/"
		
		connection {
			type		= "ssh"
			user		= "ec2-user"
			private_key	= "${file(var.private_key_path)}"
			#agent		= true 
		}
	}

	provisioner "file" {
		source      = "script/"
		destination = "$HOME"
		
		connection {
			type		= "ssh"
			user		= "ec2-user"
			private_key	= "${file(var.private_key_path)}"
			#agent		= true
		}
	}
	
	provisioner "remote-exec" {
		inline = [
			"mkdir script",
			"sudo mv *.sh script/",
			"echo 'Change permission for exucution'",
			"sudo chmod 777 /$HOME/script/*",
			"echo '[Permission changed succsefully on all files...]'",
			"ls -lart /$HOME/script/",
			"echo '[Start provisining...]'",
			"cd /$HOME/script",
			"./install_web.sh"
		]
		
		connection {
			type		= "ssh"
			host		= "${aws_instance.web-1.public_ip}"
			user		= "ec2-user"
			private_key	= "${file(var.private_key_path)}"
			#agent		= true
		}
	}
    tags {Name = "Web Server 1"}
}

resource "aws_eip" "web-1" {
    instance = "${aws_instance.web-1.id}"
    vpc = true
}
