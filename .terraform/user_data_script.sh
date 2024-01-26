#!/bin/bash

# Important note:
# The following commands will be run as a root user, not as a ec2-user. The "home" directory (~) will be root user's home directory

# install docker
sudo yum update -y
sudo yum install -y docker
sudo service docker start

# install docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir ~/app

sudo aws s3 cp s3://${AWS_S3_BUCKET}/dev-envs/${BRANCH_NAME}/docker-compose.yml ~/app/docker-compose.yml
echo "APP_IMAGE_PATH=${AWS_ECR_REPOSITORY_URL}:${BRANCH_NAME}" >> ~/app/.env


sudo aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.eu-central-1.amazonaws.com

sudo docker-compose -f ~/app/docker-compose.yml --env-file ~/app/.env up