variable "name" {
  description = "The name of the CodePipeline"
  type        = string
  default     = "default_pipeline_name"
}

variable "role_arn" {
  description = "The ARN of the IAM role that CodePipeline assumes"
  type        = string
}

variable "artifact_store" {
  description = "Artifact store configuration for CodePipeline"
  type = object({
    location = string
    type     = string
  })
}

variable "github_owner" {
  description = "GitHub repository owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "Branch to use for deployment"
  type        = string
}

variable "github_secret_arn" {
  description = "ARN of the GitHub OAuth token stored in AWS Secrets Manager"
  type        = string
}
resource "aws_codepipeline" "custom_pipeline" {
  name     = var.name
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store.location
    type     = var.artifact_store.type
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = var.github_owner
        Repo       = var.github_repo
        Branch     = var.github_branch
        OAuthToken = var.github_secret_arn
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"
      configuration = {
        ProjectName = var.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CloudFormation"
      input_artifacts = ["build_output"]
      version         = "1"
      configuration = {
        ActionMode     = "CHANGE_SET_REPLACE"
        StackName      = "placeholder-stack"
        ChangeSetName  = "placeholder-changeset"
        TemplatePath   = "build_output::template.yaml"
        Capabilities   = "CAPABILITY_NAMED_IAM"
      }
    }
  }

  tags = {
    Name = var.name
  }
}

output "pipeline_name" {
  value = aws_codepipeline.custom_pipeline.name
}
