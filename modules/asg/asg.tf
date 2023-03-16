resource "aws_launch_configuration" "main" {
  
  name_prefix = "$(var.env_code)"
  image_id = data.aws_ami.amazonlinux.id
  instance_type = "t2.micro"
  key_name = "awskey"
  user_data = file("${path.module}/user_data.sh")
  security_groups = [aws_security_group.private.id]
  iam_instance_profile = aws_iam_instance_profile.main.name

}

resource "aws_autoscaling_group" "main" {
  name = var.env_code

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  target_group_arns    = [var.target_group_arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = var.subnet_id

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }

}

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Private sg"
  vpc_id      = var.vpc_id
 

  ingress {
    description     = "HTTP fro load balancer"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.lb_sg_id]
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






