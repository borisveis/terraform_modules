data "aws_region" "current" {}

resource "aws_codebuild_project" "codebuild" {
  count = var.artifact_type == "NO_ARTIFACTS" ? 1 : 0

  name          = var.name
  description   = "CodeBuild project for ${var.name}"
  build_timeout = var.build_timeout
  service_role  = var.service_role_arn
  source_version = var.source_branch

  # GitHub as the source
  source {
    type        = "GITHUB"               # GitHub as the source type
    location    = var.source_location    # URL of the GitHub repo
    buildspec   = var.buildspec          # Path to your buildspec file
    git_clone_depth = 1                  # Limit git clone depth to the latest commit
  }

  # Environment block to define the build environment
  environment {
    compute_type                = var.codebuild_computeType  # Compute type (e.g., BUILD_GENERAL1_SMALL)
    image                       = var.codebuild_image       # Docker image to use for the build
    type                        = "LINUX_CONTAINER"         # Environment type
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode       # Docker-in-Docker for privileged builds
  }

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [var.vpc_id] : []

    content {
      vpc_id               = var.vpc_id
      subnets              = var.vpc_subnets
      security_group_ids   = var.vpc_security_group_ids
    }
  }

  # Define artifacts (if any, based on the artifact_type variable)
  artifacts {
    type= "NO_ARTIFACTS"
    location                = var.artifact_location
    name                    = var.artifact_name
    path                    = var.artifact_path
    packaging               = var.artifact_packaging
    namespace_type         = var.artifact_namespace_type
    override_artifact_name = var.artifact_override_name
  }
}
