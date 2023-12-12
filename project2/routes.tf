# Route table for public subnet 1
resource "aws_route_table" "publicRT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "PublicRouteTable"
    }
}


#Route table association to public subnet 
resource "aws_route_table_association" "publicRT1association" {
    subnet_id       = aws_subnet.publicSubnet1.id
    route_table_id  = aws_route_table.publicRT.id
}
