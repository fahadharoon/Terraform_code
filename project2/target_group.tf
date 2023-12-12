#####################################################################
## AWS Target Group
#####################################################################

resource "aws_lb_target_group" "alb_tg" {
name = "tcw-tg"
port = 80
protocol = "HTTP"
vpc_id = aws_vpc.myvpc.id
}