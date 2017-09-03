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
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {Name = "DBServerSG"}
}

resource "aws_instance" "db-1" {
	ami = "${var.amis}"
	availability_zone = "us-east-1b"
	private_ip = "10.0.1.100"
	instance_type = "t2.micro"
	key_name = "${var.key_name}"
	vpc_security_group_ids = ["${aws_security_group.db.id}"]
	subnet_id = "${aws_subnet.us-east-1-private.id}"
	source_dest_check = false
	provisioner "remote-exec" {
		inline = [
			"sudo hostnamectl set-hostname db-server",
			"sudo echo '10.0.0.10	nat' >> /etc/hosts",
			"sudo echo '10.0.0.100	web-server' >> /etc/hosts",
			"sudo echo '10.0.1.100	db-server' >> /etc/hosts"
		]
		
		connection {
			type		= "ssh"
			user		= "ec2-user"
			agent		= true
		}
	}
	
    tags {Name = "DB Server 1"}
}