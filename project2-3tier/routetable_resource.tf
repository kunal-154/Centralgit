resource "aws_route_table" "Tier3-rt" {
  vpc_id = aws_vpc.Tier3-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Tier3-rt"
  }
}

resource "aws_route_table_association" "public-route-1" {
  subnet_id      = aws_subnet.public-1.id
  route_table_id = aws_route_table.Tier3-rt.id
}


resource "aws_default_route_table" "dfltrt" {
  default_route_table_id = aws_vpc.Tier3-vpc.default_route_table_id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_nat_gateway.Tier3-nat.id
  }

  tags = {
        Name = "dfltrt"
  }
}


resource "aws_security_group" "public-sg" {
  name        = "public-sg"
  description = "Allow web and SSH traffic"
  vpc_id      = aws_vpc.Tier3-vpc.id

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private-sg" {
  name        = "private-sg"
  description = "Allow web tier and SSH traffic"
  vpc_id      = aws_vpc.Tier3-vpc.id

  ingress {
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
    security_groups = [aws_security_group.public-sg.id]
  }
  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

