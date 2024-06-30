provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "ak-vpc" {
  cidr_block = var.aws_cidr_block_vpc
  tags = {
    Name = "AK-VPC"
  }
}

resource "aws_subnet" "ak-public-subnet" {
  vpc_id = aws_vpc.ak-vpc.id
  cidr_block = var.aws_cidr_block_subnet
  availability_zone = var.aws_availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "AK-SN"
  }
}

