resource "aws_security_group" "public" {
  name        = "${var.env_code}-public"
  description = "Public sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}/32"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}-public"
  }
}

resource "aws_instance" "public" {
  ami                         = data.aws_ami.amazonlinux.id # ap-south-1
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "awskey"
  vpc_security_group_ids      = [aws_security_group.public.id]
  subnet_id                   = aws_subnet.public[0].id
}


resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Private sg"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "allow_tls"
  }
}



resource "aws_instance" "private" {
  ami           = data.aws_ami.amazonlinux.id # ap-south-1
  instance_type = "t2.micro"
  key_name      = "awskey"

  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = aws_subnet.private[0].id
}

