output "public_ip" {
  value = aws_instance.public.public_ip

}

output "private_ip" {
  value = aws_instance.private.private_ip
}