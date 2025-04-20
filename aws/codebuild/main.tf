data "aws_region" "current" {}

resource "aws_codebuild_project" "codebuild" {
  name            = var.name
  description     = "CodeBuild project for ${var.name}"
  build_timeout   = var.build_timeout
  service_role    = var.service_role_arn
  source_version  = var.source_branch

  source {
    type           = "GITHUB"
    location       = var.source_location
    buildspec      = var.buildspec
    git_clone_depth = 1
  }

  environment {
    compute_type                = var.codebuild_computeType
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [var.vpc_id] : []

    content {
      vpc_id               = var.vpc_id
      subnets              = var.vpc_subnets
      security_group_ids   = var.vpc_security_group_ids
    }
  }

    artifacts {
    type = var.artifact_type
        location                = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_location : null
    name                    = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_name : null
    path                    = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_path : null
    packaging               = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_packaging : null
    namespace_type         = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_namespace_type : null
    override_artifact_name = var.artifact_type != "NO_ARTIFACTS" ? var.artifact_override_name : null
  }
}
