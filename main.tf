
resource "aws_vpc" "cb-vpc" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true

  tags = {
    Name = "Tolu-vpc"
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.cb-vpc.id

  tags = {
    Name = local.company
  }
}

resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.cb-vpc.id
  cidr_block              = "10.0.0.0/28"
  map_public_ip_on_launch = true

  tags = { Name = local.company }
}


resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.cb-vpc.id
  cidr_block              = "10.0.0.16/28"
  map_public_ip_on_launch = true

  tags = { Name = local.company }
}

resource "aws_subnet" "private-subnet1" {
  vpc_id     = aws_vpc.cb-vpc.id
  cidr_block = "10.0.0.32/28"

  tags = { Name = local.company }
}

resource "aws_route_table" "rt-subnet1" {
  vpc_id = aws_vpc.cb-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "subnet1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.rt-subnet1.id
}

resource "aws_route_table" "rt-subnet2" {
  vpc_id = aws_vpc.cb-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}
resource "aws_route_table_association" "subnet2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.rt-subnet2.id
}

resource "aws_security_group" "sg" {
  name   = "ec2_instance_sg"
  vpc_id = aws_vpc.cb-vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = local.company
  }
}


# INSTANCES #
resource "aws_instance" "ubuntu1" {
  #   count                  = var.instance_count
  #   ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  ami                    = "ami-0e5f882be1900e43b"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet1.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  key_name      = "idan"
  user_data = file("${path.module}/templates/startup_script.tpl")

}

resource "aws_instance" "ubuntu2" {
  #   count                  = var.instance_count
  #   ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  ami                    = "ami-0e5f882be1900e43b"
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public-subnet2.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  user_data              = file("${path.module}/templates/startup_script.tpl")
}