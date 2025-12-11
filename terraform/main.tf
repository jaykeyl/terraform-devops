data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] 
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow HTTP inbound"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = length(var.ami) > 0 ? var.ami : data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "terraform-upb-web"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2

    # index.html con contenido
    cat > /var/www/html/index.html <<HTML
    <!doctype html>
    <html>
      <head><meta charset="utf-8"><title>UPB 2025</title></head>
      <body>
        <h1>UPB 2025</h1>
        <p>Desplegado con Terraform + GitHub Actions</p>
      </body>
    </html>
    HTML

    # Asegurar que apache escucha en 80 (Ubuntu usa 80 por defecto)
    systemctl enable apache2
    systemctl restart apache2
  EOF

  user_data_replace_on_change = true
}

output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP of EC2 instance"
}

output "public_dns" {
  value       = aws_instance.web.public_dns
  description = "Public DNS of EC2 instance"
}
