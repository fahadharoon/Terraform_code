################################################################################
# Autoscaling group
################################################################################

resource "aws_autoscaling_group" "autoscaling_group" {
  name = "tcw_autoscaling_group"
  vpc_zone_identifier = [aws_subnet.publicSubnet1.id, aws_subnet.publicSubnet2.id]

  min_size         = 1
  max_size         = 1
  desired_capacity = 1
  launch_configuration = aws_launch_configuration.lc.name
  target_group_arns = [aws_lb_target_group.alb_tg.arn]
 tag {
  key                 = "ecs_key"
  value               = "MyApp"
  propagate_at_launch = true
}


  depends_on = [
    aws_lb_target_group.alb_tg
  ]
}