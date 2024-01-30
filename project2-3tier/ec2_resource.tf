resource "aws_instance" "web-1" {
  ami           = "ami-03f4878755434977f" # us-west-2
  instance_type = "t2.micro"
  key_name = "neww-key"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.public-sg.id]
  subnet_id = aws_subnet.public-1.id
  associate_public_ip_address = true
  tags = {
  	Name = "web-1-instance"
  }
}

resource "aws_instance" "web-2" {
  ami           = "ami-03f4878755434977f" # us-west-2
  instance_type = "t2.micro"
  key_name      = "neww-key"
  availability_zone = "ap-south-1b"
  vpc_security_group_ids = [aws_security_group.public-sg.id]
  subnet_id = aws_subnet.public-2.id
  associate_public_ip_address = true
  tags = {
        Name = "web2-instance-Tier3"
  }
}



resource "aws_instance" "db-instance" {
  ami           = "ami-03f4878755434977f" # us-west-2
  instance_type = "t2.micro"
  key_name      = "neww-key"
  availability_zone = "ap-south-1a"
  vpc_security_group_ids = [aws_security_group.private-sg.id]
  subnet_id = aws_subnet.private-1.id
  associate_public_ip_address = false
  tags = {
        Name = "db-instance"
  }
}



