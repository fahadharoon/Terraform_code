#Create VPC
resource "aws_vpc" "myvpc" {
    cidr_block = "15.0.0.0/16"
    tags = {
        Name = "MyVPC"
    }
}