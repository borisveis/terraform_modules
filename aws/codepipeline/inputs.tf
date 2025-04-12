variable "name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for CodePipeline"
  type        = string
}

variable "artifact_store" {
  description = "Artifact store configuration"
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

variable "codebuild_project_name" {
  description = "CodeBuild project name"
  type        = string
}
