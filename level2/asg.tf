resource "aws_launch_configuration" "main" {
  
  name_prefix = "$(var.env_code)"
  image_id = data.aws_ami.amazonlinux.id
  instance_type = "t2.micro"
  key_name = "awskey"
  user_data = file("user_data.sh")
  security_groups = [aws_security_group.private.id]

}

resource "aws_autoscaling_group" "main" {
  name = var.env_code

  min_size         = 2
  desired_capacity = 2
  max_size         = 4

  target_group_arns    = [aws_lb_target_group.main.arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = data.terraform_remote_state.level1.outputs.private_subnet_ids

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }

}