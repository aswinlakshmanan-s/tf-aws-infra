locals {
  # Extract the RDS host from the DB instance endpoint.
  rds_host = split(":", aws_db_instance.csye6225_rds.endpoint)[0]
}

resource "aws_launch_template" "webapp_lt" {
  name          = var.launch_template_name
  image_id      = var.custom_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids  = [aws_security_group.app_sg.id]
  disable_api_termination = var.disable_api_termination

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access_profile.name
  }

  block_device_mappings {
    device_name = var.device_name
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = aws_kms_key.ec2_key.arn
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    exec > >(tee -a /var/log/user_data.log | logger -t user-data -s 2>/dev/console) 2>&1
    set -e

    echo "[BOOTSTRAP] Updating and installing tools..."
    apt-get update -y && apt-get install -y jq unzip curl

    echo "[BOOTSTRAP] Installing AWS CLI"
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip && sudo ./aws/install

    REGION="${var.aws_region}"
    SECRET_NAME="${aws_secretsmanager_secret.rds_password.name}"
    DB_HOST="${aws_db_instance.csye6225_rds.address}"
    DB_PORT="${aws_db_instance.csye6225_rds.port}"

    echo "[INFO] Fetching DB password from Secrets Manager..."
    SECRET_JSON=$(aws secretsmanager get-secret-value \
      --region "$REGION" \
      --secret-id "$SECRET_NAME" \
      --query SecretString \
      --output text 2>/tmp/aws_error.log) || {
        echo "[ERROR] Failed to fetch secret"
        cat /tmp/aws_error.log
        exit 1
    }
    DB_PASS=$(echo "$SECRET_JSON" | jq -r .password)

    mkdir -p /opt/csye6225/webapp

    cat <<EOT > /opt/csye6225/webapp/.env
    DB_HOST=$${DB_HOST}
    DB_PORT=$${DB_PORT}
    DB_NAME=${var.database_name}
    DB_USER=${var.database_user}
    DB_PASSWORD=$${DB_PASS}
    AWS_BUCKET_NAME=${aws_s3_bucket.profile_pic_bucket.bucket}
    AWS_REGION=${var.aws_region}
    PORT=${var.app_port}
    NODE_ENV=${var.environment}
    EOT

    chown csye6225:csye6225 /opt/csye6225/webapp/.env
    chmod 600 /opt/csye6225/webapp/.env

    echo "[INFO] Restarting csye6225.service"
    systemctl daemon-reexec
    systemctl restart csye6225.service || echo "[WARN] csye6225.service failed to start"

    echo "[INFO] Script complete."
  EOF
  )


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}
