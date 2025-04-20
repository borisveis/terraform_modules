resource "aws_codepipeline" "code_pipeline" {
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

variable "name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for the pipeline"
  type        = string
}

variable "github_owner" {
  description = "GitHub owner (username or org)"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
}

variable "github_branch" {
  description = "GitHub branch name"
  type        = string
}

variable "github_secret_arn" {
  description = "GitHub token ARN from Secrets Manager"
  type        = string
}

variable "artifact_store_location" {
  description = "S3 location for the artifact store"
  type        = string
}

variable "artifact_store_type" {
  description = "The type of artifact store"
  type        = string
}
