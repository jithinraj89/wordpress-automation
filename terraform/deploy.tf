provider "aws" {
    region = "${var.aws_region}"
}

module "vpc_subnets" {
	source = "./modules/vpc_subnets"
	name = "icflix"
	environment = "dev"
	enable_dns_support = true
	enable_dns_hostnames = true
	vpc_cidr = "172.16.0.0/16"
        public_subnets_cidr = "172.16.10.0/24,172.16.20.0/24"
        private_subnets_cidr = "172.16.30.0/24,172.16.40.0/24"
        azs    = "us-east-2a,us-east-2b"
}

module "ssh_sg" {
	source = "./modules/ssh_sg"
	name = "icflix"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "web_sg" {
	source = "./modules/web_sg"
	name = "icflix"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
	source_cidr_block = "0.0.0.0/0"
}

module "elb_sg" {
	source = "./modules/elb_sg"
	name = "icflix"
	environment = "dev"
	vpc_id = "${module.vpc_subnets.vpc_id}"
}

module "rds_sg" {
    source = "./modules/rds_sg"
    name = "icflix"
    environment = "dev"
    vpc_id = "${module.vpc_subnets.vpc_id}"
    security_group_id = "${module.web_sg.web_sg_id}"
}

module "ec2key" {
	source = "./modules/ec2key"
	key_name = "Icflix"
	public_key = "${var.public_key}"
}

module "ec2" {
	source = "./modules/ec2"
	name = "icflix"
	environment = "dev"
	server_role = "web"
	ami_id = "${var.ami_id}"
	key_name = "${module.ec2key.ec2key_name}"
	count = "1"
	security_group_id = "${module.ssh_sg.ssh_sg_id},${module.web_sg.web_sg_id}"
	subnet_id = "${module.vpc_subnets.public_subnets_id}"
	instance_type = "t2.nano"
	user_data = "#!/bin/bash\napt-get -y update\napt-get -y install nginx\n"
}

module "rds" {
	source = "./modules/rds"
	name = "icflix"
	environment = "dev"
	storage = "8"
	engine_version = "5.7.19"
	db_name = "wordpress"
	username = "root"
	password = "${var.rds_password}"
	security_group_id = "${module.rds_sg.rds_sg_id}"
	subnet_ids = "${module.vpc_subnets.private_subnets_id}"
}

module "elb" {
	source = "./modules/elb"
	name = "icflix"
	environment = "dev"
	security_groups = "${module.elb_sg.elb_sg_id}"
	availability_zones = "us-east-2a,us-east-2b"
	subnets = "${module.vpc_subnets.public_subnets_id}"
	instance_id = "${module.ec2.ec2_id}"
}

module "route53" {
	source = "./modules/route53"
	hosted_zone_id = "${var.hosted_zone_id}"
	domain_name = "${var.domain_name}"
	elb_address = "${module.elb.elb_dns_name}"
	elb_zone_id = "${module.elb.elb_zone_id}"

}
