resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Security Group for ALB"
  vpc_id      = aws_vpc.Tier3-vpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}


resource "aws_lb" "Tier3-alb" {
  name               = "Tier3-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public-1.id, aws_subnet.public-2.id]
}


resource "aws_lb_target_group" "Tier3-tg" {
  name     = "Tier3-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.Tier3-vpc.id

  depends_on = [aws_vpc.Tier3-vpc]
}


resource "aws_lb_target_group_attachment" "tg-attach-1" {
  target_group_arn = aws_lb_target_group.Tier3-tg.arn
  target_id        = aws_instance.web-1.id
  port             = 80

  depends_on = [aws_instance.web-1]
}

resource "aws_lb_target_group_attachment" "tg-attach-2" {
  target_group_arn = aws_lb_target_group.Tier3-tg.arn
  target_id        = aws_instance.web-2.id
  port             = 80

  depends_on = [aws_instance.web-2]
}

resource "aws_lb_listener" "listener-lb" {
  load_balancer_arn = aws_lb.Tier3-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.Tier3-tg.arn
  }
}

