resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Private sg"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id
 

  ingress {
    description     = "HTTP fro load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.load_balancer.id]
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





