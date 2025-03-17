output "instance_public_ip" {
  description = "Public IP of the launched web application instance"
  value       = aws_instance.app_instance.public_ip
}
