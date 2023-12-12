# Create ALB
resource "aws_lb" "alb" {
  name               = "ApplicationLoadBalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  
  # Reference subnet IDs directly
  subnets = [
    aws_subnet.publicSubnet1.id,
    aws_subnet.publicSubnet2.id
  ]

#   enable_deletion_protection = true

  tags = {
    Environment = "dev"
  }
}
