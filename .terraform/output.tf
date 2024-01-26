output "ec2_ip_address" {
  value = aws_eip.one.public_ip
}

