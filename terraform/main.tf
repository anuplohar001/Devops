provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

# Generate a private key locally
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create an AWS key pair from the public key
resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = tls_private_key.example.public_key_openssh
}

# Save the private key locally
resource "local_file" "private_key" {
  content          = tls_private_key.example.private_key_pem
  filename         = "${path.module}/example-key.pem"
  file_permission  = "0600"
}



resource "aws_security_group" "existing_sg" {
  name = "MyHttpSG"
  description = "Allow ssh access"
  vpc_id = "vpc-0e5e75d01462041da"

  ingress {
    description = "Custom TCP"
    from_port = 30000
    to_port = 32767
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress  {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SMTPS"
    from_port = 465
    to_port = 465
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP"
    from_port = 6379
    to_port = 6379
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP Range"
    from_port = 3000
    to_port = 10000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "SMTP"
    from_port = 25
    to_port = 25
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom TCP for Kubernetes API"
    from_port = 6443
    to_port = 6443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Launch an EC2 instance with the key pair
resource "aws_instance" "master" {
  ami           = "ami-020cba7c55df1f615"  # Amazon Linux 2 in us-east-1
  instance_type = "t2.micro"
  key_name      = aws_key_pair.example.key_name

  vpc_security_group_ids = [
    aws_security_group.existing_sg.id
  ]

  root_block_device {
    volume_size = 30
    volume_type = "gp2"
  }

  tags = {
    Name = "Master-Instance"
  }
}

