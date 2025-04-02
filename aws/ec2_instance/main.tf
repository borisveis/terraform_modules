provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "aws_vpc" {
  filter {
    name = "isDefault"
    values = ["true"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name = "state"
    values = ["available"]
  }
}

resource "aws_instance" "ec2_instance" {
  ami           = data.aws_ami.latest_amazon_linux.id
  instance_type = var.instance_type

  subnet_id = var.subnet.id
  associate_public_ip_address = true

  tags = {
    Name = var.instance_name
  }
}
