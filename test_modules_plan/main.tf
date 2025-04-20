# main.tf
provider "aws" {
  region = "us-west-1"
  default_tags {
    tags = {
      Environment = "Dev"
      Project     = "CI/CD Pipeline"
    }
  }
}

#Data Sources
data "aws_vpc" "default" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

#S3
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket        = "borisveispipelineartifacttesting"
  force_destroy = false

  

  
}

#IAM Roles
resource "aws_iam_role" "codepipeline_role" {
  name               = "CodePipelineServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = "CodeBuildServiceRole"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json
}

# --- IAM Policies ---
data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "CodePipelinePolicy"
  role = aws_iam_role.codepipeline_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.pipeline_artifacts.arn}/*"
      },
      {
        Action   = ["codebuild:BatchGetBuilds", "codebuild:StartBuild"],
        Effect   = "Allow",
        Resource = aws_codebuild_project.terraform.arn
      }
    ]
  })
}

resource "aws_iam_role_policy" "codebuild_policy" {
  name = "CodeBuildPolicy"
  role = aws_iam_role.codebuild_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["s3:GetObject", "s3:GetObjectVersion", "s3:PutObject"],
        Effect   = "Allow",
        Resource = "${aws_s3_bucket.pipeline_artifacts.arn}/*"
      },
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect   = "Allow",
        Resource = "arn:aws:logs:us-west-1:*:log-group:/aws/codebuild/${aws_codebuild_project.terraform.name}:*"
      }
    ]
  })
}

#CodeBuild Project
resource "aws_codebuild_project" "terraform" {
  name          = "terraform-build"
  description   = "Terraform validation and execution"
  service_role  = aws_iam_role.codebuild_role.arn
  build_timeout = "10"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "hashicorp/terraform:1.3.7"
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name  = "TF_IN_AUTOMATION"
      value = "true"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOT
      version: 0.2
      phases:
        install:
          commands:
            - terraform --version
        build:
          commands:
            - terraform init
            - terraform validate
            - terraform plan -out=tfplan
      artifacts:
        files:
          - tfplan
    EOT
  }
}

#CodePipeline
resource "aws_codepipeline" "terraform" {
  name     = "terraform-infra-pipeline"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName       = "my-repo" # Update with real repo
        BranchName           = "main"
        PollForSourceChanges = false
      }
    }
  }

  stage {
    name = "Validate"
    action {
      name             = "Validate"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["validated_output"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.terraform.name
      }
    }
  }
}

output "pipeline_arn" {
  value = aws_codepipeline.terraform.arn
}

output "artifact_bucket" {
  value = aws_s3_bucket.pipeline_artifacts.bucket
}
