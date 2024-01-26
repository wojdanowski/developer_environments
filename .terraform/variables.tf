variable "BRANCH_NAME" {
  description = "feature/branch name that will be used to build the environment, do not use / character"
  type        = string
}
variable "AWS_ECR_REPOSITORY_URL" {
  description = "Ecr account url"
  type        = string
}
variable "AWS_S3_BUCKET" {
  description = "Ecr account url"
  type        = string
}
variable "AWS_REGION" {
  type = string
}
