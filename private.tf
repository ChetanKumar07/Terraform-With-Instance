/*
  Database Servers
*/
resource "aws_security_group" "db" {
  name        = "Private_db"
  description = "Allow incoming database connections."

  ingress {
    from_port = 1433 # SQL Server

    to_port         = 1433
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }
  ingress {
    from_port = 3306 # MySQL

    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.default.id

  tags = {
    Name = "DBServerSG"
  }
}

resource "aws_instance" "db-1" {
  ami                    = "ami-08706cb5f68222d09"
  instance_type          = "t2.micro"
  key_name               = "MyKeyPair"
  vpc_security_group_ids = [aws_security_group.db.id]
  count                  = length(var.private_subnet_cidr)
  subnet_id              = element(aws_subnet.private.*.id, count.index)
  source_dest_check      = false

  tags = {
    Name = "Private_DB Server 1"
  }
}

