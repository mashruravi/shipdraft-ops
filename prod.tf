variable "region" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "database_user" {
  type = string
}

variable "database_password" {
  type = string
}

provider "aws" {
  profile = "default"
  region  = var.region
  shared_credentials_file = "./credentials"
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "prod_web" {
  name        = "prod_web"
  description = "Allow standard http and https ports inbound and everything outbound."

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Terraform" = "true"
  }

}

resource "aws_instance" "prod_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]

  tags = {
    "Terraform" = "true"
  }
}

resource "aws_db_instance" "prod_db" {
  identifier          = "shipdraft-prod-db"
  name                = "shipdraft"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "10.9"
  port                = "3306"
  username            = var.database_user
  password            = var.database_password
  skip_final_snapshot = true
  publicly_accessible = true

  vpc_security_group_ids = [
    aws_security_group.prod_web.id
  ]
  
  tags = {
    "Terraform" = "true"
  }
}
