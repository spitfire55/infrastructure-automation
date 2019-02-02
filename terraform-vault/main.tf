resource "aws_vpc" "pinhead_vpc" {
    cidr_block = "${var.vpc_cidr_block}"
}

resource "aws_subnet" "pinhead_subnet" {
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    vpc_id = "${aws_vpc.pinhead_vpc.id}"
    cidr_block = "${var.subnet_cidr_block}"
}

resource "aws_security_group" "pinhead_security_group" {
    name_prefix = "${var.name_prefix}"
    description = "Security group for the ${var.name_prefix} launch configuration"
    vpc_id = "${aws_vpc.pinhead_vpc.id}"
}

resource "aws_security_group_rule" "allow_inbound_traffic_to_puppet_master_from_cidr_blocks" {
    count = "${length(var.allowed_cidr_blocks) >= 1 ? 1 : 0}"
    type = "ingress"
    protocol = "tcp"
    from_port = 8140
    to_port = 8140
    cidr_blocks = ["${var.allowed_cidr_blocks}"]
    security_group_id = "${aws_security_group.pinhead_security_group.id}"
}

resource "aws_security_group_rule" "allow_inbound_traffic_to_puppet_master_from_security_group_ids" {
    count = "${length(var.allowed_security_group_ids)}"
    type = "ingress"
    to_port = "8140"
    source_security_group_id = "${element(var.allowed_security_group_ids, count.index)}"
    security_group_id = "${aws_security_group.pinhead_security_group.id}"
}

resource "aws_security_group_rule" "allow_all_outbound" {
    type        = "egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.pinhead_security_group.id}"
}

data "aws_ami" "vault_ami" {
    most_recent = true 
    owners = ["${var.aws_owner_id}"]
    filter {
        name = "name"
        values = ["vault-consul*"]
    }
}

/*
data "aws_ami" "puppet_master_ami" {
    most_recent = true
    owners = ["${var.aws_owner_id}"]
    filter { 
        name = "name"
        values = ["puppet-master*"]
    }
}

module "puppet-master" {
    source = "modules/puppet-master"
    ami_id = "${data.aws_ami.puppet_master_ami.id}"
    instance_type = "t3.medium"
}
*/

module "vault" {
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    source = "modules/vault"
    ami_id = "${data.aws_ami.vault_ami.id}"
    instance_type = "t3.micro"
    vpc_security_group_id = "${aws_security_group.pinhead_security_group.id}"
    subnet_id = "${aws_subnet.pinhead_subnet.id}"

}

provider "aws" {
    region = "us-east-1"
}

data "aws_availability_zones" "available" {
    state = "available"
}