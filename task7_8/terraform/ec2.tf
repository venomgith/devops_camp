provider "aws" {
  access_key = ""                     # Your akey
  secret_key = "" # Your skey  
  region     = "us-east-1"
}

resource "aws_instance" "ansible_server" {
  count = 1
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ansible_sg.id]
  key_name               = aws_key_pair.tfkey.key_name

  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
  tags = var.tags
}

resource "aws_key_pair" "tfkey" {
  key_name   = "tfkey"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  file_permission = "0400"
  filename = "${abspath("${dirname(path.module)}/../sshkey/tfkey.pem")}"
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansibleSC"
  description = "ansibleSC Terraform"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "instance_public_ip" {
  description = "Public_IP_EC2"
  value       = aws_instance.ansible_server.*.public_ip
}


# Generate inventory file Ansible
data "template_file" "ansible_inventory" {
  template = <<EOF
[group1]
VM1 ansible_host=${aws_instance.ansible_server.0.public_ip}
EOF
}

# Write inventory file on local disk
resource "local_file" "ansible_inventory" {
  content  = data.template_file.ansible_inventory.rendered
  filename = "${abspath("${dirname(path.module)}/../templates/ansible-inventory.yml")}"
}

# Создаем ресурс data для шаблона group_vars
data "template_file" "group_vars" {
  template = <<EOF
---
ansible_user : ubuntu
ansible_ssh_private_key_file : ${resource.local_file.TF-key.filename}
EOF
}

# Создаем ресурс для записи group_vars файла на локальном диске
resource "local_file" "group_vars" {
  content  = data.template_file.group_vars.rendered
  filename = "${abspath("${dirname(path.module)}/../templates/group_vars/group1.yml")}" 
}

# Создаем ansible.cfg
data "template_file" "ansiblecfg" {
  template = <<EOF
[defaults]
host_key_checking = false
inventory         = ${abspath("${dirname(path.module)}/../templates/ansible-inventory.yml")}
EOF
}

# Создаем ресурс для записи ansible.cfg файла на локальном диске
resource "local_file" "ansiblecfg" {
  content  = data.template_file.ansiblecfg.rendered
  filename = "${abspath("${dirname(path.module)}/../templates/ansible.cfg")}"
}