module "iam_policy_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "policy"
}

resource "aws_iam_policy" "ec2_policy" {
  name        = module.iam_policy_label.id
  description = "Policy to procide aws cli permissions to ec2"

  policy = jsonencode({
    "Version" : "2012-10-17",
    Statement = [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:ListBucket",
          "ecr:*"
        ],
        "Resource" : [
          "arn:aws:s3:::${var.AWS_S3_BUCKET}/dev-envs/${var.BRANCH_NAME}/*",
          "arn:aws:ecr:${var.AWS_REGION}:${local.account_id}:repository/dev-envs/*",
          "*"
        ]
      }
    ]
  })
}


module "iam_role_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "role"
}
resource "aws_iam_role" "ec2_role" {
  name = module.iam_role_label.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

#Attach role to policy
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "custom" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}


module "iam_ec2_profile_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  context = module.label.context
  name    = "profile"
}
#Attach role to an instance profile
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = module.iam_ec2_profile_label.id
  role = aws_iam_role.ec2_role.name
}
