# Those code samples are ment to help you set terraform locally in a way that it would be set up by CI

# Name of the branch where "/" was replaced by "-"
# Eg: "feature-env/add-log-in" would be changed to "feature-env-add-log-in" by CI pipeline
export TF_VAR_BRANCH_NAME=feature-env-clean-up
# Bucket name where you store your terraform state and other files needed for the deployment
export TF_VAR_AWS_S3_BUCKET=terraform-state-wojdanowski
export TF_VAR_AWS_REGION=eu-central-1

terraform init \
  -backend-config "key=dev-envs/$TF_VAR_BRANCH_NAME/terraform.tfstate" \
  -backend-config "bucket=$TF_VAR_AWS_S3_BUCKET" \
  -backend-config "region=$TF_VAR_AWS_REGION" \
  -reconfigure

