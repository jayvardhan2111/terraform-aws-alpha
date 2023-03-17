output "load_balancer_url" {
  value = aws_lb.main.dns_name
}

output "load_balancer_sg" {
  value = aws_security_group.load_balancer.id
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}


