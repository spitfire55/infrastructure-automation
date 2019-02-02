# REQUIRED VARIABLES
variable "ami_id" {
    description = "The AMI ID for Vault. This should have been built with Packer"
}

variable "instance_type" {
    description = "The EC2 instance type to use for the Vault instance"
}

variable "vpc_security_group_id" {
    description = "The VPC ID that we want to place the Vault instance within"
}

variable "subnet_id" {
    description = "The subnet within the VPC that Vault will belong in."
}

# OPTIONAL VARIABLES
# Make iam_instance_profile required in the future
variable "iam_instance_profile" {
    description = "The IAM profile that has the necessary permissions to conduct the Vault install and Vault run configuration"
    default = ""
}

variable "root_volume_type" {
    description = "The type of root block device to use for Vault storage"
    default = "standard"
}

variable "root_volume_size" {
    description = "The amount of space to allocate to the root volume"
    default = 50
}

variable "availability_zone" {
    description = "The availability zone to use within the region specified by the AWS provider"
    default = "us-east-1a"
}
