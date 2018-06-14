provider "aws" {
    region = "${var.aws_region}"
}

module "efs_creation" {
  source = "./modules/efs_creation"
  name = "${var.name}"
  subnets = "${var.subnets}"
  availability_zones = "${var.availability_zones}"
  security_groups = "${var.security_groups}"
}

