provider "aws" {
    access_key 	= "${var.aws_access_key}"
    secret_key 	= "${var.aws_secret_key}"
    region 		= "${var.aws_region}"
}

resource "aws_key_pair" "ljubon-key-webapp" {
  key_name   = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

<<<<<<< HEAD

=======
# test
>>>>>>> 7b91d85c6f7479392445988095e28242d8dfd670
output "public_web" {
	value = "${aws_eip.web-1.public_ip}"
}
output "public_nat" {
	value = "${aws_eip.nat.public_ip}"
}
output "private_web" {
	value = "${aws_instance.web-1.private_ip}"
}
output "private_db" {
	value = "${aws_instance.db-1.private_ip}"
}
output "private_nat" {
	value = "${aws_instance.nat.private_ip}"
}
