provider "aws" {
  region = "us-east-1"
}

variable "main_cidr" {}
variable "subnet_cidr" {}
variable "owner" {}
variable "environment" {}


resource "aws_vpc" "main-vpc" {
  cidr_block =  var.main_cidr
  tags = {
    Name = "first_vpc"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main-vpc.id

  tags = {
    Name = "first_igw"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id = aws_vpc.main-vpc.id 
  cidr_block = var.subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "first_public subnet"
    Environment = "var.environment"
    Owner = var.owner
  }
}

resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main-vpc.id
 route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "first_route_table"
    Environment = var.environment
    Owner = var.owner
  }
}

resource "aws_route_table_association" "route_assoc" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.main_route_table.id
}
