resource "aws_vpc" "main" {
  cidr_block = "10.1.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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

resource "aws_s3_bucket" "charts" {
  bucket = "unir-tfm-chartmuseum-bucket"

  tags = {
    Name        = "ChartMuseumBucket"
    Environment = "dev"
  }
}

data "aws_ami" "amazon_linux_arm" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

resource "aws_instance" "chartmuseum" {
  ami                         = data.aws_ami.amazon_linux_arm.id
  instance_type               = "t4g.small"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker -y
              service docker start
              usermod -a -G docker ec2-user
              
              # Wait for Docker to be ready
              sleep 30
              
              # Pull the image first to avoid timeout issues
              docker pull chartmuseum/chartmuseum:latest
              
              # Run ChartMuseum with better resource limits
              docker run -d \
                --name chartmuseum \
                --restart unless-stopped \
                -p 80:8080 \
                -e STORAGE=amazon \
                -e STORAGE_AMAZON_BUCKET=unir-tfm-chartmuseum-bucket \
                -e STORAGE_AMAZON_REGION=${var.aws_region} \
                -e AWS_ACCESS_KEY_ID=${var.aws_access_key} \
                -e AWS_SECRET_ACCESS_KEY=${var.aws_secret_key} \
                chartmuseum/chartmuseum:latest
              EOF

  tags = {
    Name = "chartmuseum"
  }
}
