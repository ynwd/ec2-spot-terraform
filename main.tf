variable "key_name" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_spot_instance_request" "app_server" {
  ami           = "ami-07651f0c4c315a529"
  instance_type = "t3.nano"
  #   key_name      = "deployer-two"
  key_name = aws_key_pair.generated_key.key_name


  tags = {
    Name = "ExampleAppServerInstance"
  }
}


resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

output "private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
