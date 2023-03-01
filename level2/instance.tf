resource "aws_security_group" "public" {
  name        = "${var.env_code}-public"
  description = "Public sg"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description = "SSH from public"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_public_ip}/32"]

  }
  ingress {
    description = "Access from public"
    from_port   = 80
    to_port     = 80
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

  count = 2

  ami                         = data.aws_ami.amazonlinux.id # ap-south-1
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = "awskey"
  user_data                   = file("user_data.sh")
  vpc_security_group_ids      = [aws_security_group.public.id]
  subnet_id                   = data.terraform_remote_state.level1.outputs.public_subnet_ids[count.index]

  tags = {
    Name = "${var.env_code}-public${count.index}"
  }


}


resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Private sg"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id
  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.terraform_remote_state.level1.outputs.vpc_cidr]

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
  count = 2
  ami           = data.aws_ami.amazonlinux.id # ap-south-1
  instance_type = "t2.micro"
  key_name      = "awskey"

  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = data.terraform_remote_state.level1.outputs.private_subnet_ids[count.index]
  tags = {
    Name = "${var.env_code}-private"
  }

}


