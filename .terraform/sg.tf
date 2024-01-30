module "sg_internal_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "internal"
}

resource "aws_security_group" "internal" {
  name        = module.sg_internal_label.id
  description = "Allow internal inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  depends_on  = [aws_vpc.my_vpc]

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.internal_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.sg_internal_label.tags
}

module "sg_http_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "http"
}

resource "aws_security_group" "http" {
  name        = module.sg_http_label.id
  description = "Allow HTTP(S) inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  depends_on  = [aws_vpc.my_vpc]

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.sg_http_label.tags
}

module "sg_ssh_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "ssh"
}


resource "aws_security_group" "ssh" {
  name        = module.sg_ssh_label.id
  description = "Allow SSH access"
  vpc_id      = aws_vpc.my_vpc.id
  depends_on  = [aws_vpc.my_vpc]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = module.sg_ssh_label.tags
}

module "sg_rds_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "rds"
}

resource "aws_security_group" "rds" {
  name        = module.sg_rds_label.id
  description = "Allow PostgreSQL inbound traffic"
  vpc_id      = aws_vpc.my_vpc.id
  depends_on  = [aws_vpc.my_vpc]

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = local.internal_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = local.internal_cidr_blocks
  }

  tags = module.sg_rds_label.tags
}

