output "public-subnet" {
    value = aws_subnet.public-subnet.id
  
}
output "vpc_id" {
    value = aws_vpc.Example.id
}
output "security_group_id" {
  value = aws_security_group.web-SG.id
}