output "instance_public_ip" {
  description = "Public IP of the launched web application instance"
  value       = aws_instance.web_app.public_ip
}

output "s3_bucket_name" {
  description = "Name of the private S3 bucket"
  value       = aws_s3_bucket.profile_pic_bucket.bucket
}

output "rds_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = aws_db_instance.csye6225_rds.endpoint
}
