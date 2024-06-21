resource "aws_vpc" "Example" {
        cidr_block = var.vpc_cidr_block
        tags = {
          Name = "Example"
        }
}
resource "aws_subnet" "public-subnet" {
        vpc_id = aws_vpc.Example.id
        cidr_block = var.public_subnet_cidr
        availability_zone = "ap-south-1a"
        tags = {
          Name = "public-subnet"
        }
}
resource "aws_subnet" "private-subnet" {
    vpc_id = aws_vpc.Example.id
    cidr_block = var.private_subnet_cidr
    availability_zone = "ap-south-1b"
    tags = {
      Name = "private-subnet"
    }
}
resource "aws_internet_gateway" "Example-igw" {
    vpc_id = aws_vpc.Example.id
    tags = {
      Name = "Example-igw"
    }
}
resource "aws_route_table" "pub-rt" {
    vpc_id = aws_vpc.Example.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.Example-igw.id
    }
    tags = {
      Name = "public-rt"
    }
}
resource "aws_route_table_association" "public-route" {
        subnet_id = aws_subnet.public-subnet.id
        route_table_id = aws_route_table.pub-rt.id
}
resource "aws_route_table" "private-rt" {
    vpc_id = aws_vpc.Example.id
    
}
resource "aws_route_table_association" "private-route" {
    subnet_id = aws_subnet.private-subnet.id
    route_table_id = aws_route_table.private-rt.id
}
resource "aws_security_group" "web-SG" {
    name = "web-sg"
    vpc_id = aws_vpc.Example.id
    ingress{
	description	= "HTTP for VPC"
	from_port	= 80
	to_port		= 80
	protocol	= "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
	ingress{
	description = "SSH for VPC"
	from_port	= 22
	to_port		= 22
	protocol	= "tcp"
	cidr_blocks = ["0.0.0.0/0"]
	}
    egress{
	from_port	= 0
	to_port		= 0
	protocol	= "-1"
	cidr_blocks	= ["0.0.0.0/0"]
	}
	tags = {
		Name = "web-SG"
	} 
}