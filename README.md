<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo_text.svg" width="320" alt="Nest Logo" /></a>
    <a href="http://nestjs.com/" target="blank"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Terraform_Logo.svg/1200px-Terraform_Logo.svg.png" width="320" alt="Nest Logo" /></a>
</p>

#On-Demand Environments setup
## Description

Experimental concept of on-demand environment setup. Brand new feature environment can be provisioned on AWS and destroyed by managing branches directly from GitHub

On demand enviroment, containing only specific feature changes can be usefull for testing and in trunk-based development.

## Installation
```bash
$ npm install
```

## Prerequisites
- AWS account
- CircleCi account and CircleCI project configured/connected to Github repository
- Terraform installed and configured to have access to AWS account

## Environment variables
### CircleCi context or project variables

```
AWS_ACCESS_KEY_ID
AWS_ACCOUNT_ID
AWS_DEFAULT_REGION
AWS_ECR_REPOSITORY_URL
AWS_S3_BUCKET
AWS_SECRET_ACCESS_KEY
CACHE_VERSION_TIMESTAMP
```

## How to provision the dev-environment
CircleCi pipeline is triggered when a change is pushed to the branch matching `feature-env/<your-branch-name>` pattern.
Feature environment will be provisioned using Terraform config.
Image containing code from your branch will be build and deployed to AWS ECR.

When EC2 instance is up, an image from ECR is run inside docker container using docker-compose.yml passed to the instance by AWS S3 - directly uploaded from from CI pipeline and downloaded by the bash script on EC2.

## How to destroy the environment
### Regular flow
GitHub actions are configured to manually trigger CircleCi pipeline that will destroy the environemnt whenever a `feature-env/...` branch is deleted. This can be easily modified to trigger whenever PR or branch is merged etc.

### CircleCi pipeline safety hatch
When pipeline that should provision the environemt will exit with non 0 code a `terraform destroy` command is run to make sure there are no useless resourcess created on the AWS account.


