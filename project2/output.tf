output "lc_name" {
  value = aws_launch_configuration.lc.name
}

output "lb_dns_name" {
  value = aws_lb.alb.dns_name
}
