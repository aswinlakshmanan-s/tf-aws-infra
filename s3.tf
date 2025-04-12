# Generate a unique bucket name using a UUID
resource "random_uuid" "bucket_name" {}

# Create the S3 bucket with a unique UUID name
resource "aws_s3_bucket" "profile_pic_bucket" {
  bucket = "${var.s3_bucket_prefix}-${lower(random_uuid.bucket_name.result)}"

  # Enable force destroy to delete the bucket even if it has objects
  force_destroy = var.s3_force_destroy

  tags = {
    Name        = var.s3_bucket_name
    Environment = var.environment
  }
}

# Block all public access to the bucket
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  block_public_acls       = var.s3_block_public_acls
  block_public_policy     = var.s3_block_public_policy
  ignore_public_acls      = var.s3_ignore_public_acls
  restrict_public_buckets = var.s3_restrict_public_buckets
}

# Enable server-side encryption for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = aws_kms_key.s3_key.arn
    }
  }
}

# Define a lifecycle configuration to transition objects to STANDARD_IA after 30 days
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  rule {
    id     = var.s3_lifecycle_rule_id
    status = var.s3_lifecycle_status

    filter {
      prefix = ""
    }

    transition {
      days          = var.s3_transition_days
      storage_class = var.s3_transition_storage_class
    }

    expiration {
      days = var.s3_expiration_days
    }
  }
}

# S3 Bucket Policy allowing access to IAM role
resource "aws_s3_bucket_policy" "private_access_policy" {
  bucket = aws_s3_bucket.profile_pic_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.s3_access_role.arn
        },
        Action = var.s3_allowed_actions,
        Resource = [
          aws_s3_bucket.profile_pic_bucket.arn,
          "${aws_s3_bucket.profile_pic_bucket.arn}/*"
        ]
      },
      {
        Effect    = "Deny",
        Principal = "*",
        Action    = var.s3_denied_actions,
        Resource = [
          aws_s3_bucket.profile_pic_bucket.arn,
          "${aws_s3_bucket.profile_pic_bucket.arn}/*"
        ],
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}
