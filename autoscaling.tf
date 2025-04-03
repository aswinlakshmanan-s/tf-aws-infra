resource "aws_autoscaling_group" "webapp_asg" {
  name                      = var.asg_name
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  desired_capacity          = var.asg_desired_capacity
  vpc_zone_identifier       = aws_subnet.public_subnets[*].id
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  default_cooldown          = var.default_cooldown

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
    value               = var.asg_tag_value
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "scale_up" {
  name                   = var.scale_up_policy_name
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  scaling_adjustment     = var.scale_up_adjustment
  cooldown               = var.scale_up_cooldown
  adjustment_type        = var.scale_up_adjustment_type
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = var.cpu_high_alarm_name
  comparison_operator = var.cpu_high_comparison_operator
  evaluation_periods  = var.cpu_high_evaluation_periods
  metric_name         = var.cpu_high_metric_name
  namespace           = var.cpu_high_namespace
  period              = var.cpu_high_period
  statistic           = var.cpu_high_statistic
  threshold           = var.cpu_high_threshold
  alarm_description   = var.cpu_high_alarm_description
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_up.arn]
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = var.scale_down_policy_name
  autoscaling_group_name = aws_autoscaling_group.webapp_asg.name
  scaling_adjustment     = var.scale_down_adjustment
  cooldown               = var.scale_down_cooldown
  adjustment_type        = var.scale_down_adjustment_type
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = var.cpu_low_alarm_name
  comparison_operator = var.cpu_low_comparison_operator
  evaluation_periods  = var.cpu_low_evaluation_periods
  metric_name         = var.cpu_low_metric_name
  namespace           = var.cpu_low_namespace
  period              = var.cpu_low_period
  statistic           = var.cpu_low_statistic
  threshold           = var.cpu_low_threshold
  alarm_description   = var.cpu_low_alarm_description
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_down.arn]
}
