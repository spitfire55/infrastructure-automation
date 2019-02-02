# REQUIRED VARIABLES
variable "name_prefix" {
    description = "The name of this Terraform configuration."
}

variable "aws_owner_id" {
    description = "The owner ID of our AWS account in order to find our AMIs"
}

# OPTIONAL VARIABLES
variable "vpc_cidr_block" {
    description = "CIDR block for the Pinhead VPC. Must be larger than the subnet CIDR block."
    default = "192.168.0.0/16"
}

variable "subnet_cidr_block" {
    description = "CIDR block for the Pinhead subnet within the VPC. Must be smaller than the VPC CIDR block."
    default = "192.168.0.0/24"
}

variable "allowed_cidr_blocks" {
    description = "The CIDR blocks external to Pinhead that are allowed to communicate to this VPC."
    type = "list"
    default = []
}

variable "allowed_security_group_ids" {
    description = "The list of security groups IDs that are allowed to talk to the VPC."
    type = "list"
    default = []
}