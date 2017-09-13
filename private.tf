/*
  Database Servers
*/

resource "aws_security_group" "db" {
    name = "vpc_db"
    description = "Allow incoming database connections."

    ingress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
    }
    ingress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]

    }
	ingress { # MySQL
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = ["${aws_security_group.web.id}"]
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
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

	egress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {Name = "DBServerSG"}
}

resource "aws_instance" "db-1" {
	ami = "${var.amis}"
	availability_zone = "${var.availability_zone}"
	private_ip = "10.0.1.100"
	instance_type = "t2.micro"
	key_name = "${var.key_name}"
	vpc_security_group_ids = ["${aws_security_group.db.id}"]
	subnet_id = "${aws_subnet.us-east-1-private.id}"
	source_dest_check = false


	# Create folders
	provisioner "remote-exec" {
		inline = [
			"mkdir script",
			"mkdir ansible",
			"echo 'Create folders...DONE' "
		]
		connection {
			# connect thourh NAT instance
			host				= "${aws_instance.db-1.private_ip}"
			type				= "ssh"
			user				= "ec2-user"
			private_key			= "${file(var.private_key_path)}"
			bastion_host 		= "${aws_eip.web-1.public_ip}"
			bastion_user		= "ec2-user"
			bastion_private_key = "${file(var.private_key_path)}"
		}
	}

	# local script/ -> remote /$HOME/script/
	provisioner "file" {
		source      = "script/"
		destination = "$HOME/script"
		connection {
			# connect thourh NAT instance
			host				= "${aws_instance.db-1.private_ip}"
			type				= "ssh"
			user				= "ec2-user"
			private_key			= "${file(var.private_key_path)}"
			bastion_host 		= "${aws_eip.web-1.public_ip}"
			bastion_user		= "ec2-user"
			bastion_private_key = "${file(var.private_key_path)}"
		}
	}

	# ansible/ -> $HOME/ansible
	provisioner "file" {
		source      = "ansible/"
		destination = "$HOME/ansible"
		connection {
			# connect thourh NAT instance
			host				= "${aws_instance.db-1.private_ip}"
			type				= "ssh"
			user				= "ec2-user"
			private_key			= "${file(var.private_key_path)}"
			bastion_host 		= "${aws_eip.web-1.public_ip}"
			bastion_user		= "ec2-user"
			bastion_private_key = "${file(var.private_key_path)}"
		}
	}

	# .ssh/jenkins* -> $HOME/.ssh/
	provisioner "file" {
		source = "/home/ec2-user/.ssh/jenkins"
		destination = "/home/ec2-user/.ssh/jenkins"
		connection {
			# connect thourh NAT instance
			host				= "${aws_instance.db-1.private_ip}"
			type				= "ssh"
			user				= "ec2-user"
			private_key			= "${file(var.private_key_path)}"
			bastion_host 		= "${aws_eip.web-1.public_ip}"
			bastion_user		= "ec2-user"
			bastion_private_key = "${file(var.private_key_path)}"
		}
	}

	provisioner "remote-exec" {
		inline = [
			"echo '[Change permission for exucution]'",
			"sudo chmod 777 /$HOME/script/*",
			"echo '[Permission changed succsefully on all files /home/ec2-user/script/]' ",
			"ls -lart /$HOME/script/",
			"ls -lart /$HOME/ansible/",
			"echo '[Start provisining...]'",
			"cd /$HOME/script",
			"./install_db.sh"
		]
		connection {
			# connect thourh NAT instance
			host				= "${aws_instance.db-1.private_ip}"
			type				= "ssh"
			user				= "ec2-user"
			private_key			= "${file(var.private_key_path)}"
			bastion_host 		= "${aws_eip.web-1.public_ip}"
			bastion_user		= "ec2-user"
			bastion_private_key = "${file(var.private_key_path)}"
		}
	}
    tags {Name = "DB Server 1"}
}

# test 321
# test 321
# test 321
# test 321
