resource "aws_instance" "public_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  subnet_id     = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.public_sg.id]

  tags = {
    Name = "Public Jump Host"
  }
}

resource "aws_instance" "private_instance" {
  count          = 2
  ami            = var.ami_id
  instance_type  = var.instance_type
  key_name       = var.key_name
  subnet_id      = var.private_subnet_id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  tags = {
    Name = "Private Instance ${count.index + 1}"
  }
}


resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Security group for public instance"
  vpc_id      = var.vpc_id

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

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for private instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.public_sg.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "local_file" "ansible_playbook_file" {
  content = templatefile("/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/ansible/playbook.tpl", {
    public_ip       = aws_instance.public_instance.public_ip
  })
  filename = "/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/ansible/playbook.yml"
  depends_on = [aws_instance.public_instance]
}

resource "local_file" "ansible_inventory_file" {
  content = templatefile("/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/ansible/inventory.tpl", {
    public_ip       = aws_instance.public_instance.public_ip
    private_ips     = [for instance in aws_instance.private_instance : instance.private_ip]
  })
  filename = "/Users/SuperAayush/Desktop/projects/nginxCloudAutomation/ansible/inventory.ini"
  depends_on = [aws_instance.public_instance, aws_instance.private_instance]
}

resource "null_resource" "run_ansible" {
  depends_on = [
    local_file.ansible_inventory_file,
    local_file.ansible_playbook_file,
    aws_instance.public_instance,
    aws_instance.private_instance
  ]

  triggers = {
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ./ansible/inventory.ini ./ansible/playbook.yml"
  }
}
