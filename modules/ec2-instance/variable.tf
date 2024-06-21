variable "ami_id" {
    description = "This is ami id for ec2-instance"
}
variable "instance_type" {
    description = "Instance type of EC2"
}
variable "subnet_id" {
  description = "Give the subnet for EC2"
}
variable "security_group" {
  description = "Assign the security group"
}