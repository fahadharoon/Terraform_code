#Create security group for public subnet
resource "aws_security_group" "public_sg" {
    vpc_id = aws_vpc.myvpc.id
    name   = var.sg_name

    // Ingress rule allowing inbound traffic on port 80, 443, and 22
    ingress {
        description = "HTTP"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "SSH"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        from_port   = 8111
        to_port     = 8111
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    // Egress rule allowing all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = var.sg_tagname
    }
}