<p align="center">
  <a href="http://nestjs.com/" target="blank"><img src="https://nestjs.com/img/logo_text.svg" width="320" alt="Nest Logo" /></a>
    <a href="http://nestjs.com/" target="blank"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Terraform_Logo.svg/1200px-Terraform_Logo.svg.png" width="320" alt="Nest Logo" /></a>
</p>


## Description

Experimental concept of on-demand environment setup. Brand new feature environment can be provisioned on AWS and torn managing branches from directly from github

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

## How it works
When changes to 
