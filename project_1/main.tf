terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}
provider "aws" {
  region = "ap-south-1"

}
resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "demo"
  }
}
resource "aws_subnet" "public-subnet-1" {

  vpc_id            = aws_vpc.demo.id
  cidr_block        = "10.0.0.0/25"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "public-subnet-2" {
		vpc_id				=	aws_vpc.demo.id
		cidr_block			= 	"10.0.0.128/25"
		availability_zone	= 	"ap-south-1b"
}

###create the internet gateway###

resource "aws_internet_gateway" "demo-igw" {

	vpc_id  = aws_vpc.demo.id
	
	tags = {
		Name = "demo-igw"
	}
}

###create the route table###

resource "aws_route_table" "Demo-rt" {

	vpc_id = aws_vpc.demo.id
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = aws_internet_gateway.demo-igw.id
	}
}

### create route table associations ###

resource "aws_route_table_association" "pub-rt1" {

	subnet_id       = aws_subnet.public-subnet-1.id
	route_table_id  = aws_route_table.Demo-rt.id
}
resource "aws_route_table_association" "pub-rt2" {

	subnet_id       = aws_subnet.public-subnet-2.id
	route_table_id  = aws_route_table.Demo-rt.id
}



resource "aws_security_group" "web-SG" {

	vpc_id = aws_vpc.demo.id
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

resource "aws_instance" "Demo-EC2" {

			ami 					= var.ami_id
			instance_type   		= var.instance_type
			subnet_id       		= aws_subnet.public-subnet-1.id
			vpc_security_group_ids 	= [aws_security_group.web-SG.id]
			user_data				= base64encode(file("userdata.sh"))
			
			tags = {
				Name = "Demo-EC2"
			}
}