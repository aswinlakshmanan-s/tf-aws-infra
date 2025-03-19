# Generate a unique bucket name using a UUID
resource "random_uuid" "bucket_name" {}

# Create the S3 bucket with a unique UUID name
resource "aws_s3_bucket" "profile_pic_bucket" {
  bucket = "profile-pic-bucket-${lower(random_uuid.bucket_name.result)}"

  # Enable force destroy to delete the bucket even if it has objects
  force_destroy = true

  tags = {
    Name        = "profile-pic-bucket"
    Environment = "Production"
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Define a lifecycle configuration to transition objects to STANDARD_IA after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  rule {
    id     = "transition-to-standard-ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 365 # Optional: Delete objects after 1 year (adjust as needed)
    }
  }
}

# IAM Role for accessing S3 bucket
resource "aws_iam_role" "s3_access_role" {
  name = "s3-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# S3 Bucket Policy allowing access to IAM role
resource "aws_s3_bucket_policy" "private_access_policy" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.s3_access_role.arn
        }
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.profile_pic_bucket.arn,
          "${aws_s3_bucket.profile_pic_bucket.arn}/*"
        ]
      },
      {
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.profile_pic_bucket.arn,
          "${aws_s3_bucket.profile_pic_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
