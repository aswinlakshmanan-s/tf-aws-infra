resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnets[*].id
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "app_tg" {
  name     = var.tg_name
  port     = var.app_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.main_vpc.id

  health_check {
    healthy_threshold   = var.hc_healthy_threshold
    unhealthy_threshold = var.hc_unhealthy_threshold
    timeout             = var.hc_timeout
    interval            = var.hc_interval
    matcher             = var.hc_matcher
    path                = var.hc_path
    protocol            = var.hc_protocol
  }
}

# resource "aws_lb_listener" "http_listener" {
#   load_balancer_arn = aws_lb.app_lb.arn
#   port              = var.listener_port
#   protocol          = var.listener_protocol

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app_tg.arn
#   }
# }

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_acm_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }

  tags = {
    Environment = "demo"
  }
}
