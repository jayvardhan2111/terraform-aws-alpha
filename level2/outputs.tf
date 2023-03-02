
output "public_ip" {
  value = aws_instance.public[*].public_ip
}

output "load_balancer_url" {
  value = aws_lb.main.dns_name
}

