resource "aws_vpc" "Tier3-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Tier3-VPC"
  }
}


resource "aws_eip" "myeip" {
        domain   = "vpc"
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Tier3-vpc.id

  tags = {
    Name = "Tier3-igw"
  }
}


resource "aws_nat_gateway" "Tier3-nat" {
	allocation_id = aws_eip.myeip.id
	subnet_id = aws_subnet.public-1.id

	tags = {
	Name = "Tier3-nat"
	}

	depends_on = [aws_internet_gateway.igw]

}


resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.Tier3-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.Tier3-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.Tier3-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "private-1"
  }
}
