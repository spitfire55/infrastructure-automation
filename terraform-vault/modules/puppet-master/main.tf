module "puppetmaster" {
    source = "github.com/terraform-community-modules/tw_aws_puppet/master"
    region = "${var.region}"
    instance_type = "t3.micro"
    iam_instance_profile = "ec2-puppetmaster-describeinstances"
    aws_key_name = "${var.admin_key}"
    subnet_id = "${var.subnet_id}"
    security_group = "${var.security_group}"
    repository = "https://gitlab.com/spitfyre/puppet-master.git"
}