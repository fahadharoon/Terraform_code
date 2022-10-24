#Aws Provider

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAUHGP6VLWTCUDMDP6"
  secret_key = "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"
}

resource "aws_instance" "web" {
  subnet_id = "subnet-0f33d7f0641a35e6d"
  ami           = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "aws_key"
  vpc_security_group_ids = [ "sg-007d89f7777977a87" ]

user_data = <<-EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "Faraz Bhai ZindaBad" | sudo tee /var/www/html/index.html
EOF

  tags = {
    Name = "Ubuntu_Instance"
  }
}

