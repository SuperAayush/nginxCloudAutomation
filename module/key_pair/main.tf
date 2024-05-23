provider "tls" {}

resource "tls_private_key" "ngx_automation" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ngx_automation.public_key_openssh
}

resource "local_file" "private_key" {
  content          = tls_private_key.ngx_automation.private_key_pem
  filename         = "${path.module}/key_pair.pem"
  file_permission  = "0400"
}