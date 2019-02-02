resource "aws_network_interface" "vault_network_interface" {
    subnet_id = "${var.subnet_id}"
    security_groups = ["${var.vpc_security_group_id}"]
}

resource "aws_instance" "vault_instance" {
    availability_zone = "${var.availability_zone}"
    ami = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    iam_instance_profile = "${var.iam_instance_profile}"
    root_block_device = {
        volume_type = "${var.root_volume_type}"
        volume_size = "${var.root_volume_size}"
    }
    network_interface {
        device_index = 0
        network_interface_id = "${aws_network_interface.vault_network_interface.id}"
    }
}