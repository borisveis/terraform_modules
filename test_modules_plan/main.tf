# Pull the default VPC
data "aws_vpc" "aws_vpc" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

# Subnet for EC2 (required by ec2_instance module)
resource "aws_subnet" "default_subnet" {
  vpc_id                  = data.aws_vpc.aws_vpc.id
  cidr_block              = "172.31.0.0/16"
  availability_zone       = "us-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "test_modules"
  }
}

############################################
# IAM ROLES AND POLICIES
############################################

# CodeBuild IAM Role
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
    }]
  })
}

# CodeBuild Policy
resource "aws_iam_policy" "codebuild_policy" {
  name        = "CodeBuildPolicy"
  description = "Policy for CodeBuild Project"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["s3:*", "logs:*", "codebuild:*"]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

# Attach CodeBuild Policy
resource "aws_iam_role_policy_attachment" "codebuild_role_attach" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
}

# CodePipeline IAM Role
resource "aws_iam_role" "codepipeline_role" {
  name = "CodePipelineServiceRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach predefined AWS policies to CodePipeline role
resource "aws_iam_role_policy_attachment" "codepipeline_policy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodePipelineFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_policy_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

############################################
# MODULES
############################################

# Secrets Manager: stores GitHub token
module "secrets" {
  source            = "../aws/secrets"
  secrets_json_path = "../../secrets.json"
  name              = "Terraform_test_run"
}

# S3 Bucket for artifacts
module "s3" {
  source      = "../aws/s3"
  bucket_name = "teratest-test"
}

# CodeBuild
module "codebuild" {
  source           = "../aws/codebuild"
  name             = "codebuild_default_name"
  source_location  = "https://github.com/borisveis/LLMTesting.git"
  codebuild_image  = "aws/codebuild/standard:4.0"
  service_role_arn = aws_iam_role.codebuild_role.arn
  artifact_type    = "NO_ARTIFACTS"
}

# EC2 (for test purposes)
module "ec2" {
  source = "../aws/ec2_instance"
  subnet = aws_subnet.default_subnet
}

# IAM Role Module (optional/custom role)
module "iam_role" {
  source    = "../aws/iam_role"
  role_name = "my_role_name"
}

# CodePipeline (GitHub → Build → Deploy)
module "code_pipeline" {
  source            = "../aws/codepipeline"
  name              = "codebuild_default_name"
  github_secret_arn = module.secrets.github_token_secret_arn
  github_owner      = "borisveis"
  github_repo       = "data_synthesizer"
  github_branch     = "main"
  role_arn          = aws_iam_role.codepipeline_role.arn

  artifact_store = {
    location = module.s3.bucket_name
    type     = "S3"
  }
}

############################################
# OUTPUTS
############################################

output "bucket_arn" {
  value = module.s3.bucket_arn
}

output "codebuild_arn" {
  value = module.codebuild.codebuild_arn
}

output "secrets_arn" {
  value = module.secrets.secret_arn
}

output "pipeline_name" {
  value = module.code_pipeline.pipeline_name
}
