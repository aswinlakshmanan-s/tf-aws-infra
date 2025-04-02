resource "aws_autoscaling_group" "webapp_asg" {
  name                      = "csye6225_asg"
  max_size                  = 5
  min_size                  = 3
  desired_capacity          = 3
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "ELB"
  health_check_grace_period = 60
  default_cooldown          = 60

  launch_template {
    id      = aws_launch_template.webapp_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  tag {
    key                 = "AutoScalingGroup"
    value               = "csye6225_asg"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  scaling_adjustment     = 1
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu_high_alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 8
  alarm_description   = "Scale up if CPU utilization > 8%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  scaling_adjustment     = -1
  cooldown               = 60
  adjustment_type        = "ChangeInCapacity"
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu_low_alarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 6
  alarm_description   = "Scale down if CPU utilization < 6%"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
