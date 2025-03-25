# IAM Policy for S3 Access (for EC2 Instance)
resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Policy for EC2 instance to access S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          "${aws_s3_bucket.profile_pic_bucket.arn}/*",
          "${aws_s3_bucket.profile_pic_bucket.arn}"
        ]
      }
    ]
  })
}

# Attach the S3 Policy to the Role (for EC2 Instance)
resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach CloudWatch Agent Server Policy to the same Role
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# IAM Instance Profile for attaching IAM Role to EC2
resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "ec2-s3-access-instance-profile"
  role = aws_iam_role.s3_access_role.name
}
