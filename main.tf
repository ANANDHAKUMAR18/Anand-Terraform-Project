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

resource "aws_internet_gateway" "ak-igw" {
  vpc_id = aws_vpc.ak-vpc.id

  tags = {
    Name = "AK-IGW"
  }
}

resource "aws_route_table" "ak-rt" {
  vpc_id = aws_vpc.ak-vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ak-igw.id
  }
  
  tags = {
    Name = "AK-RT"
  }
}

resource "aws_route_table_association" "ak-rta" {
  route_table_id = aws_route_table.ak-rt.id
  subnet_id = aws_subnet.ak-public-subnet.id
}

resource "aws_security_group" "ak-sg" {
  vpc_id = aws_vpc.ak-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 

  tags = {
    Name = "AK-SG"
  }
}

resource "aws_instance" "ak-instance" {
  ami = var.aws_ami
  instance_type = var.aws_instance_type
  vpc_security_group_ids = [aws_security_group.ak-sg.id]
  key_name = var.aws_key_pair
  subnet_id = aws_subnet.ak-public-subnet.id

  tags = {
    Name = "AK-Instance"
  }

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("/home/anandhakumar/Downloads/Hello.pem")
    host = self.public_ip
  }

  provisioner "file" {
    source = "/home/anandhakumar/terra/app.py"
    destination = "/home/ubuntu/app.py"
  }

  provisioner "remote-exec" {
    inline = [ 
    "echo 'Hello from AK!'",
    "sudo apt update -y",
    "sudo apt-get install python3-pip",
    "cd /home/ubuntu",
    "sudo pip3 install flask",
    "sudo python3 app.py &",
    ]
  }
}