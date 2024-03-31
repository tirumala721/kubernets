variable "aws_region" {
  default = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CD-Project"
  }
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "CD-VPC IG"
  }
}

resource "aws_route_table" "first_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "CD-Route Table-1"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "CD-Route Table-2"
  }
}

# Define security groups
resource "aws_security_group" "instance1_sg" {
  name        = "instance1-sg"
  description = "Security group for instance 1"
}

resource "aws_security_group" "instance2_sg" {
  name        = "instance2-sg"
  description = "Security group for instance 2"
}

# Allocate Elastic IPs
resource "aws_eip" "instance1_eip" {
  instance = aws_instance.instance1.id
}

resource "aws_eip" "instance2_eip" {
  instance = aws_instance.instance2.id
}

# Define EC2 instances
resource "aws_instance" "instance1" {
  ami             = "ami-080e1f13689e07408" # Specify your desired AMI ID
  instance_type   = "t2.large"              # Specify your desired instance type
  security_groups = [aws_security_group.instance1_sg.name]
}

resource "aws_instance" "instance2" {
  ami             = "ami-080e1f13689e07408" # Specify your desired AMI ID
  instance_type   = "t2.medium"             # Specify your desired instance type
  security_groups = [aws_security_group.instance2_sg.name]
}

