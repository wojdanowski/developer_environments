module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = "dev_env"
  environment = var.BRANCH_NAME

  tags = {
    Environment = var.BRANCH_NAME
  }
}
