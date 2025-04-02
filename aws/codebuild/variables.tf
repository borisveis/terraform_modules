variable "name" {
  type        = string
  description = "The name of the CodeBuild project"
}
variable "lambda_name" {
  type        = string
  default     = "none"
}
variable "service_role_arn" {
  type        = string
  default = ""
}

variable "build_timeout" {
  default     = 60
}

variable "vpc_id" {
  default     = ""
}
variable "vpc_subnets" {
  default     = []
}
variable "vpc_security_group_ids" {
  default     = []
}

variable "artifact_packaging" {
  type        = string
  description = "The packaging of artifact"
  default     = "ZIP"
}

variable "artifact_type" {
  type        = string
  description = "The type of artifact (use NO_ARTIFACTS for GitHub, S3 for ZIP to S3)"
  default     = "NO_ARTIFACTS"
}
variable "artifact_location" {
  type        = string
  default     = ""
}
variable "artifact_path" {
  type        = string
  default     = ""
}
variable "artifact_name" {
  type        = string
  default     = ""
}
variable "artifact_override_name" {
  default     = false
}
variable "artifact_namespace_type" {
  type        = string
  default     = "NONE"
}

variable "privileged_mode" {
  default     = false
}
variable "environment_variables" {
  default     = {}
}

variable "source_type" {
  type        = string
  description = "The type of source"
  default     = "GitHub"
}
variable "source_location" {
  type        = string
  description = "The source location (eg; github repo)"
  default     = "git@github.com:borisveis/LLMTesting.git"
}
variable "source_branch" {
  type        = string
  default     = "master"
}

variable "source_file_path" {
  type        = string
  default     = ""
}
variable "source_file_path_list" {
  type        = list(string)
  default     = []
}

variable "codebuild_computeType" {
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}
variable "codebuild_image" {
  type        = string
  default     = "aws/codebuild/standard:6.0"
}

variable "buildspec" {
  type        = string
  description = "Location of buildspec file"
  default     = "buildspec.yml"
}
variable "module_depends_on" {
  type    = any
  default = null
}