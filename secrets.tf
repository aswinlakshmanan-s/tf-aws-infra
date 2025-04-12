# Generates a unique suffix for the secret name
resource "random_id" "secret_suffix" {
  byte_length = 4
}

# Secrets Manager secret with KMS key
resource "aws_secretsmanager_secret" "rds_password" {
  name        = "db-secret-store-password-${random_id.secret_suffix.hex}"
  description = "RDS database password"
  kms_key_id  = aws_kms_key.secrets_manager_key.arn

}

# Store the password in the secret
resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id = aws_secretsmanager_secret.rds_password.id
  secret_string = jsonencode({
    password = random_password.db_password.result
  })
}
