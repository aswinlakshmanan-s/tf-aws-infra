output "load_balancer_dns" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.app_lb.dns_name
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.webapp_asg.name
}

output "s3_bucket_name" {
  description = "Name of the private S3 bucket"
  value       = aws_s3_bucket.profile_pic_bucket.bucket
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.csye6225_rds.endpoint
}
