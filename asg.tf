resource "aws_autoscaling_group" "asg" {
  min_size             = 2
  max_size             = 4
  desired_capacity     = 2
  vpc_zone_identifier  = aws_subnet.private[*].id
  target_group_arns   = [aws_lb_target_group.tg.arn]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }
}

