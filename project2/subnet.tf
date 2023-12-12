# Create public subnet 1
resource "aws_subnet" "publicSubnet1" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = "15.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet1"
    }
}
# Create public subnet 2
resource "aws_subnet" "publicSubnet2" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = "15.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet2"
    }
}