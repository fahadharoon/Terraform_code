# Step 1: Create VPC
resource "aws_vpc" "myvpc" {
    cidr_block = "15.0.0.0/16"
    tags = {
        Name = "MyVPC"
    }
}

# Step 2: Create public subnet
resource "aws_subnet" "publicSubnet" {
    vpc_id           = aws_vpc.myvpc.id
    cidr_block       = "15.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
        Name = "PublicSubnet"
    }
}

# Step 3: Create private subnet
resource "aws_subnet" "privateSubnet" {
    vpc_id     = aws_vpc.myvpc.id
    cidr_block = "15.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
        Name = "PrivateSubnet"
    }
}

# Step 4: Create IGW
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
        Name = "IGW"
    }
}

# Step 5: Route table for public subnet and private subnet
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

resource "aws_route_table" "privateRT" {
    vpc_id = aws_vpc.myvpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "PrivateRouteTable"
    }
}

# Step 6: Route table association to public subnet and private subnet
resource "aws_route_table_association" "publicRTassociation" {
    subnet_id       = aws_subnet.publicSubnet.id
    route_table_id  = aws_route_table.publicRT.id
}

resource "aws_route_table_association" "privateRTassociation" {
    subnet_id       = aws_subnet.privateSubnet.id
    route_table_id  = aws_route_table.privateRT.id
}

# Step 7: Create security group for public subnet
resource "aws_security_group" "public_sg" {
    vpc_id = aws_vpc.myvpc.id
    name   = "PublicSecurityGroup"

    // Ingress rule allowing inbound traffic on port 80, 443, and 22
    ingress {
        description = "HTTP"
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        description = "HTTP"
        from_port   = 5001
        to_port     = 5001
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
    
    // Egress rule allowing all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_frontend"
    }
}

# Step 8: Create security group for private subnet
resource "aws_security_group" "private_sg" {
    vpc_id = aws_vpc.myvpc.id
    name   = "PrivateSecurityGroup"

    // Ingress rule allowing inbound traffic on port 80, 443, and 22
      ingress {
          description = "Postgres"
          from_port   = 5432
          to_port     = 5432
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

    // Egress rule allowing all outbound traffic
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_backend"
    }
}

# Step 9: Create Public EC2 instance
resource "aws_instance" "public_instance" {
    ami           = "ami-0fc5d935ebf8bc3bc"  # Replace with your desired AMI ID
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.publicSubnet.id
    key_name      = "ecs_key"

    vpc_security_group_ids = [aws_security_group.public_sg.id]

    root_block_device {
        volume_size = 8
    }

    user_data = <<-EOF
                    #!/bin/bash

                    sudo apt install git -y
                    sudo apt update -y
                    sudo apt install dotnet6 -y
                    sudo add-apt-repository ppa:rael-gc/rvm -y
                    sudo apt-get update -y
                    sudo apt install libssl1.0-dev -y

                    # Install your .NET Core 6 application
                    mkdir /root/dotnetapp
                    cd /root/dotnetapp

                    git clone --depth 1 --branch v1.2.5 https://github.com .
                    git clone --depth 1 --branch main https://github.com 

                    cd /root/dotnetapp/DataAgreementIS4

                    sudo dotnet clean
                    sudo dotnet restore
                    sudo dotnet publish -c Release -r linux-x64 -o MYAPP --self-contained

                    cd /root/dotnetapp
                    cp ServerConfigs_QA/WebOMS-QA/DataAgreement-API/WebOMS_QA_79/* DataAgreementIS4/MYAPP/

                
                EOF

    tags = {
        Name = "PublicInstance"
    }
}

# Step 10: Create Private EC2 instance
resource "aws_instance" "private_instance" {
    ami           = "ami-0fc5d935ebf8bc3bc"  # Replace with your desired AMI ID
    instance_type = "t2.micro"
    subnet_id     = aws_subnet.privateSubnet.id
    key_name      = "ecs_key"

    vpc_security_group_ids = [aws_security_group.private_sg.id]

    root_block_device {
        volume_size = 8
    }

    user_data = <<-EOF
                #!/bin/bash
                # Update the package list
                sudo apt update -y

                # Install PostgreSQL
                sudo apt install postgresql postgresql-contrib -y

                # Start and enable PostgreSQL service
                sudo systemctl start postgresql
                sudo systemctl enable postgresql

                # Create a PostgreSQL user and database
                sudo -u postgres psql -c "CREATE USER myuser WITH PASSWORD 'mypassword';"
                sudo -u postgres psql -c "CREATE DATABASE mydatabase;"
                sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;"

                # Adjust PostgreSQL configuration to allow remote connections (if needed)
                # Replace '0.0.0.0/0' with the appropriate IP range or address if necessary
                echo "host all all 0.0.0.0/0 md5" | sudo tee -a /etc/postgresql/*/main/pg_hba.conf
                echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/*/main/postgresql.conf

                # Restart PostgreSQL to apply the changes
                sudo systemctl restart postgresql
              EOF

    tags = {
        Name = "PrivateInstance"
    }
}

# Step 11: Create network interface for public EC2
resource "aws_network_interface" "public_nic" {
    subnet_id = aws_subnet.publicSubnet.id

    tags = {
        Name = "public_network"
    }
}

# # Step 12: Create network interface for private EC2
resource "aws_network_interface" "private_nic" {
    subnet_id = aws_subnet.privateSubnet.id

    tags = {
        Name = "private_network"
    }
}
