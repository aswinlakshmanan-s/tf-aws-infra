data "aws_caller_identity" "current" {}

resource "random_id" "kms_suffix" {
  byte_length = 4
}

resource "aws_kms_key" "ec2_key" {
  description             = "KMS key for EC2 EBS encryption"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = var.key_rotation_status
  rotation_period_in_days = var.rotation_period


  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        "Sid" : "AllowRootAccountToManageKey",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        "Action" : ["kms:*"],

        "Resource" : "*"
      },
      {
        "Sid" : "AllowEC2InstanceRoleAccess",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.s3_access_role.name}"
        },
        "Action" : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowEC2Service",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowSecretsManagerServiceUse",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "secretsmanager.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowRDSServiceUse",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "rds.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowS3ServiceUse",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "s3.amazonaws.com"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowTerraformUserToUseKey",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/demo-user"
        },
        "Action" : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowAutoScalingService",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "autoscaling.amazonaws.com"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "AllowServiceLinkedRoleAutoScaling",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
        },
        "Action" : [
          "kms:CreateGrant",
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_kms_key" "rds_key" {
  description             = "KMS key for RDS storage encryption"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = var.key_rotation_status
  rotation_period_in_days = var.rotation_period
  policy                  = aws_kms_key.ec2_key.policy
}

resource "aws_kms_key" "s3_key" {
  description             = "KMS key for S3 bucket encryption"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = var.key_rotation_status
  rotation_period_in_days = var.rotation_period
  policy                  = aws_kms_key.ec2_key.policy
}

resource "aws_kms_key" "secrets_manager_key" {
  description             = "KMS key for Secrets Manager"
  deletion_window_in_days = var.deletion_window
  enable_key_rotation     = var.key_rotation_status
  rotation_period_in_days = var.rotation_period
  policy                  = aws_kms_key.ec2_key.policy
}

resource "aws_kms_alias" "ec2_key_alias" {
  name          = "alias/tf-ec2-encryption-key-${random_id.kms_suffix.hex}"
  target_key_id = aws_kms_key.ec2_key.key_id
}

resource "aws_kms_alias" "rds_key_alias" {
  name          = "alias/tf-rds-encryption-key-${random_id.kms_suffix.hex}"
  target_key_id = aws_kms_key.rds_key.key_id
}

resource "aws_kms_alias" "s3_key_alias" {
  name          = "alias/tf-s3-encryption-key-${random_id.kms_suffix.hex}"
  target_key_id = aws_kms_key.s3_key.key_id
}

resource "aws_kms_alias" "secrets_manager_key_alias" {
  name          = "alias/tf-secrets-encryption-key-${random_id.kms_suffix.hex}"
  target_key_id = aws_kms_key.secrets_manager_key.key_id
}
