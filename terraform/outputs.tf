output "instance_ip" {
  value = aws_instance.master.public_ip
}

output "aws_region" {
  value = var.aws_region
}
