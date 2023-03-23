resource "aws_instance" "aws_server" {
  ami                    = var.ami
  instance_type          = "t2.small"
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  key_name               = aws_key_pair.sshkey.key_name
  user_data              = file("C:\\Users\\95\\Desktop\\DevOps_lessons\\git\\task6_terraform\\modules\\aws\\grafana.sh")

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
  tags = var.tags
}

resource "aws_key_pair" "sshkey" {
  key_name   = "sshkey"
  public_key = file(var.ssh_key_path)
}

resource "aws_security_group" "aws_sg" {
  name        = "AwsSC"
  description = "AwsSC Terraform"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 3000
    to_port     = 3000
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

output "instance_public_ip_AWS" {
  description = "Public_IP_EC2"
  value       = aws_instance.aws_server.public_ip
}