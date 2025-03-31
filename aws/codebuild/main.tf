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

  # Conditionally add the artifacts block if necessary
  dynamic "artifacts" {
    for_each = var.artifact_type != "NO_ARTIFACTS" ? [1] : []

    content {
      type                    = var.artifact_type
      location                = var.artifact_location
      name                    = var.artifact_name
      path                    = var.artifact_path
      packaging               = var.artifact_packaging
      namespace_type         = var.artifact_namespace_type
      override_artifact_name = var.artifact_override_name
    }
  }
}
