resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}

# Attach an IAM Policy (Adjust permissions as needed)
resource "aws_iam_policy" "codebuild_policy" {
  name        = "CodeBuildPolicy"
  description = "Policy for CodeBuild Project"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:*", "logs:*", "codebuild:*"] # Adjust based on your requirements
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "codebuild_role_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

module "codebuild" {
  source = "../aws/codebuild"
  name     = "terratest_learn"
  source_location="https://github.com/borisveis/LLMTesting.git"
  codebuild_image   = "aws/codebuild/standard:4.0"
  service_role_arn = aws_iam_role.codebuild_role.arn # Pass the IAM role ARN to the module
 artifact_type     = "NO_ARTIFACTS"
}
output "bucket_arn" {
  value = module.s3.bucket_arn
}
output "codebuild_arn" {
  value = module.codebuild.codebuild_arn
}

module "s3" {
  source = "../aws/s3"
bucket_name = "teratest-test"
}
module "ec2" {
  source = "../aws/ec2_instance"
}