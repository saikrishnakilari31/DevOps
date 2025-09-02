#!/bin/bash
set -e
# install docker & start
yum update -y
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# pull container (you will replace with real image)
docker run -d --name myapp -e DB_HOST="${db_host}" -e DB_USER="${db_user}" -e DB_PASS="${db_pass}" -e DB_NAME="${db_name}" -p ${app_port}:8080 your-ecr-repo/myapp:latest
