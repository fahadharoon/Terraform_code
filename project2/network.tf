#Create network
resource "aws_network_interface" "public_nic1" {
    subnet_id = aws_subnet.publicSubnet1.id

    tags = {
        Name = "public_network1"
    }
}