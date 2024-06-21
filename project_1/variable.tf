variable "ami_id" {
    description = "EC2 ami id"
    type        = string
    default     = "<ami_id>"
}
variable "instance_type" {
    description = "type of aws_instance"
    type        = string
    default     = "t2.micro"
}