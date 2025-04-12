resource "aws_iam_role" "s3_access_role" {
  name = "ec2-s3-access-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "s3_access_policy" {
  name        = "s3-access-policy"
  description = "Policy for EC2 instance to access S3"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket", "s3:DeleteObject"],
        Resource = [
          aws_s3_bucket.profile_pic_bucket.arn,
          "${aws_s3_bucket.profile_pic_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "kms_and_secret_access" {
  name = "kms-secret-access"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = [
          aws_kms_key.secrets_manager_key.arn,
          aws_kms_key.ec2_key.arn,
          aws_kms_key.rds_key.arn,
          aws_kms_key.s3_key.arn,
          "${aws_secretsmanager_secret.rds_password.arn}"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_kms_secret_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = aws_iam_policy.kms_and_secret_access.arn
}

resource "aws_iam_role_policy_attachment" "attach_cloudwatch_policy" {
  role       = aws_iam_role.s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "s3_access_profile" {
  name = "ec2-s3-access-instance-profile"
  role = aws_iam_role.s3_access_role.name
}
