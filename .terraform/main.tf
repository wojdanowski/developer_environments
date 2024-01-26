terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = "1.6.6"

  backend "s3" {
    # https://github.com/hashicorp/terraform/issues/13022#issuecomment-294262392
    # key     = "dev-environments/${var.BRANCH_NAME}/terraform.tfstate"
    # Using variables (var.BRANCH_NAME) in this config is not allowed by terraform. 
    # Provide partial config, missing configuration must be provided from command line where you can use envs
    # https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration
    encrypt = true
  }
}
provider "aws" {
  region = var.AWS_REGION
}

data "aws_availability_zones" "available" {}


resource "aws_instance" "myvm" {
  ami                  = "ami-025a6a5beb74db87b" // Amazon Linux 2023 AMI
  instance_type        = "t2.micro"
  key_name             = "dev-envs"
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.web_server.id
  }


  tags = {
    Environment = var.BRANCH_NAME
    Name        = var.BRANCH_NAME
  }


  user_data_base64 = base64encode("${templatefile("./user_data_script.sh", {
    AWS_S3_BUCKET          = var.AWS_S3_BUCKET
    BRANCH_NAME            = var.BRANCH_NAME
    AWS_ECR_REPOSITORY_URL = var.AWS_ECR_REPOSITORY_URL
    AWS_REGION             = var.AWS_REGION
    AWS_ACCOUNT_ID         = local.account_id
  })}")
}
