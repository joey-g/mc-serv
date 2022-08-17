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
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t3a.small"
  key_name = "KP3"
  vpc_security_group_ids = ["sg-01198b8cdf1929380"]

  tags = {
    Name = "Minecraft Server"
  }

  user_data = file("userdata.sh")
}
