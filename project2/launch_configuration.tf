resource "aws_launch_configuration" "lc" {
  name_prefix   = "tcw_lc"
  image_id      = var.ami
  instance_type = var.instance_type

  user_data = filebase64("${path.module}/userdata_script.sh")

#   user_data = <<-EOF
#               #!/bin/bash
#               sudo apt update -y
#               sudo apt install apache2 -y

#               # Start Apache
#               sudo systemctl start apache2

#               # Enable Apache to start on boot
#               sudo systemctl enable apache2

#               # Get the instance IP address
#               INSTANCE_IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

#               # Get the CPU percentage usage
#               CPU_PERCENTAGE=$(mpstat 1 1 | awk '/^Average:/ {print 100 - $NF}')

#               # Create an HTML file with the instance information
#               sudo tee /var/www/html/index.html > /dev/null <<HTML
#               <!DOCTYPE html>
#               <html lang="en">
#               <head>
#                   <meta charset="UTF-8">
#                   <meta name="viewport" content="width=device-width, initial-scale=1.0">
#                   <title>Instance Information</title>
#                   <style>
#                       body {
#                           font-family: 'Arial', sans-serif;
#                           background-color: #282c34;
#                           color: white;
#                           text-align: center;
#                           padding: 50px;
#                       }
#                       h1 {
#                           color: #61dafb;
#                       }
#                       p {
#                           font-size: 18px;
#                           margin-top: 20px;
#                       }
#                   </style>
#               </head>
#               <body>
#                   <h1>Instance Information</h1>
#                   <p>Instance IP Address: <strong>$INSTANCE_IP</strong></p>
#                   <p>CPU Percentage Usage: <strong>$CPU_PERCENTAGE%</strong></p>
#               </body>
#               </html>
#               HTML

#               # Restart Apache to apply changes
#               sudo systemctl restart apache2
#             EOF



  key_name                  = var.keyname
  associate_public_ip_address = true
  security_groups           = [aws_security_group.public_sg.id]

  root_block_device {
    volume_size = 8
  }
}
