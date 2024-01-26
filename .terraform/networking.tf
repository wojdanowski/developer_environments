module "networking_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "networking"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.BRANCH_NAME
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name = module.networking_label.id
  }
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.my_gw.id
  }

  tags = {
    Name = module.networking_label.id
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  depends_on = [aws_internet_gateway.my_gw]

  tags = {
    Name = module.networking_label.id
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}


resource "aws_network_interface" "web_server" {
  subnet_id       = aws_subnet.my_subnet.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.http.id, aws_security_group.internal.id, aws_security_group.rds.id, aws_security_group.ssh.id]
}

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web_server.id
  associate_with_private_ip = "10.0.1.50"

  depends_on = [aws_internet_gateway.my_gw, aws_instance.myvm]
}
