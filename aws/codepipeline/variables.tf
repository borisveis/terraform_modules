variable "role_arn" {
  description = "The ARN of the IAM role that CodePipeline assumes"
  type        = string
}

variable "name" {
  description = "The name of the CodePipeline"
  type        = string
}

variable "artifact_store" {
  description = "Artifact store configuration for CodePipeline"
  type = object({
    location = string
    type     = string
  })
}

variable "codebuild_project_name" {
  description = "The name of the CodeBuild project to use"
  type        = string
}

variable "source_bucket" {
  description = "The source S3 bucket for the pipeline"
  type        = string
}
