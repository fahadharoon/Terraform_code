# Create public subnet 1
resource "aws_subnet" "publicSubnet1" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = var.pub_sub1_cidr_block
    availability_zone = var.az1
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet1"
    }
}
# Create public subnet 2
resource "aws_subnet" "publicSubnet2" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = var.pub_sub2_cidr_block
    availability_zone = var.az2
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet2"
    }
}