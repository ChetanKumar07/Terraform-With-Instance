/*
  Web Servers
*/
resource "aws_security_group" "web" {
  name        = "Public_web"
  description = "Allow incoming HTTP connections."

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "WebServerSG"
  }
}

resource "aws_instance" "web-1" {
  ami                         = "ami-08706cb5f68222d09"
  instance_type               = "t2.micro"
  key_name                    = "MyKeyPair"
  vpc_security_group_ids      = [aws_security_group.web.id]
  count                       = length(var.public_subnet_cidr)
  subnet_id                   = element(aws_subnet.public.*.id, count.index)
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "Public_Web Server 1"
  }
}


