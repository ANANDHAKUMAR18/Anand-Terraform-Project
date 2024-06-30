provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "ak-vpc" {
  cidr_block = var.aws_cidr_block_vpc
  tags = {
    Name = "AK-VPC"
  }
}
