resource "aws_vpc" "primary_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
      Name = "primary"
  }
}


resource "aws_subnet" "subnets" {
  count = length(var.subnet_cidrs)

  vpc_id = aws_vpc.primary_vpc.id
  availability_zone = var.subnet_azs[count.index]
  cidr_block = var.subnet_cidrs[count.index]

  tags = {
      Name = var.subnet_names[count.index]
  }
}

# Web Security Groups

resource "aws_security_group" "websg" {
  vpc_id = aws_vpc.primary_vpc.id

  ingress {
    description = "Open SSH For all"
    from_port = 22
    to_port = 22
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]

  }

  ingress {
    description = "Open HTTP For all"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "WebSg" 
  }
  
}
