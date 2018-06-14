resource "aws_efs_file_system" "default1" {
   tags {
    Name = "${var.name}"
  }
}

resource "aws_efs_file_system" "default2" {
   tags {
    Name = "${var.name}"
  }
}

resource "aws_efs_mount_target" "default1" {
  subnet_id       = "${var.subnets}"
  file_system_id  = "${aws_efs_file_system.default1.id}"
  
  provisioner "local-exec" {
    command = "echo DNS_NAME_MYSQL: ${aws_efs_file_system.default1.dns_name} >> ${var.name}.yml"
  }

}

resource "aws_efs_mount_target" "default2" {
  subnet_id       = "${var.subnets}"
  file_system_id  = "${aws_efs_file_system.default2.id}"
  
  provisioner "local-exec" {
    command = "echo DNS_NAME_WP: ${aws_efs_file_system.default2.dns_name} >> ${var.name}.yml"
  }

}


output "mount_target_ids1" {
  value = ["${aws_efs_mount_target.default1.dns_name}"]
}

output "mount_target_ids2" {
  value = ["${aws_efs_mount_target.default2.dns_name}"]
}