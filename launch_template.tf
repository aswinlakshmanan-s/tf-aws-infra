locals {
  rds_host = split(":", aws_db_instance.csye6225_rds.endpoint)[0]
}

resource "aws_launch_template" "webapp_lt" {
  name_prefix   = "csye6225_asg"
  image_id      = var.custom_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids  = [aws_security_group.app_sg.id]
  disable_api_termination = var.disable_api_termination

  iam_instance_profile {
    name = aws_iam_instance_profile.s3_access_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = var.root_volume_size
      volume_type           = var.root_volume_type
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    mkdir -p /opt/csye6225/webapp
    echo "DB_HOST=${local.rds_host}" >> /opt/csye6225/webapp/.env
    echo "DB_PORT=${aws_db_instance.csye6225_rds.port}" >> /opt/csye6225/webapp/.env
    echo "DB_NAME=${var.database_name}" >> /opt/csye6225/webapp/.env
    echo "DB_USER=${var.database_user}" >> /opt/csye6225/webapp/.env
    echo "DB_PASSWORD=${random_password.db_password.result}" >> /opt/csye6225/webapp/.env
    echo "AWS_BUCKET_NAME=${aws_s3_bucket.profile_pic_bucket.bucket}" >> /opt/csye6225/webapp/.env
    echo "AWS_REGION=${var.aws_region}" >> /opt/csye6225/webapp/.env
    echo "PORT=${var.app_port}" >> /opt/csye6225/webapp/.env
    echo "NODE_ENV=production" >> /opt/csye6225/webapp/.env
    chown csye6225:csye6225 /opt/csye6225/webapp/.env
    chmod 600 /opt/csye6225/webapp/.env

    cp /home/ubuntu/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
    /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json -s
    sudo systemctl restart csye6225.service
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.instance_name
    }
  }
}
