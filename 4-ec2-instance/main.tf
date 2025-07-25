resource "tls_private_key" "this" {
    algorithm = "RSA"
    rsa_bits  = 4096
  
}

resource "aws_key_pair" "this" {
    key_name   = "${var.name_prefix}-ssh"
    public_key = tls_private_key.this.public_key_openssh
  
}

resource "aws_instance" "this" {
    ami           = "ami-05ffe3c48a9991133" # Replace with a valid AMI ID
    instance_type = "t2.micro"
    key_name     = aws_key_pair.this.key_name # Replace with your key pair name

    #subnet_id = data.aws_subnet.default.id
    vpc_security_group_ids = [aws_security_group.this.id]

    associate_public_ip_address = true



    user_data = <<-EOF
            !/bin/bash
            sudo yum update -y
            sudo amazon-linux-extras install docker -y
            sudo service docker start
            sudo usermod -a -G docker ec2-user
            sudo docker run -d -p 80:80 nginx

            EOF
    tags = {
        Name = "docker-example"
    }
}

resource "aws_security_group" "this"{
    name = "${var.name_prefix}-ssh-http-sg"
    description = "Allow SSH and HTTP access"
    #vpc_id = var.vpc_id

    ingress {
        description = "SSH access"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Allow SSH from anywhere
    }

    ingress {
        description = "HTTP access"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Allow HTTP from anywhere

    }

    ingress {
        description = "HTTPS access"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] #Allow HTTP from anywhere
    }

    egress {
        from_port = 0
        to_port   = 0
        protocol  = "-1" # Allow all outbound traffic
        cidr_blocks = ["0.0.0.0/0"]
    }
}