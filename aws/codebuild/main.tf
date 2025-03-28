data "aws_region" "current" {}

resource "aws_codebuild_project" "codebuild" {
  count = var.artifact_type == "NO_ARTIFACTS" ? 1 : 0

  name          = var.name
  description   = "CodeBuild project for ${var.name}"
  build_timeout = var.build_timeout
  service_role  = var.service_role_arn
  source_version = var.source_branch

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [ var.vpc_id ] : []

    content {
      vpc_id = var.vpc_id
      subnets = var.vpc_subnets
      security_group_ids = var.vpc_security_group_ids
    }
  }

  artifacts {
    type = var.artifact_type
  }

  environment {
    compute_type                = var.codebuild_computeType
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode


       }

  source {
    report_build_status  = false
    insecure_ssl         = false
    type                 = var.source_type
    location             = var.source_location
    buildspec            = var.buildspec
    git_clone_depth      = var.source_type == "GITHUB" ? 1 : 0
  }

    provisioner "local-exec" {
    command = "aws --region ${data.aws_region.current.name} codebuild start-build --project-name ${var.name}"
  }

  depends_on = [ var.module_depends_on ]
}

resource "aws_codebuild_project" "codebuild_s3" {
  count = var.artifact_type == "S3" ? 1 : 0

  name          = var.name
  description   = "CodeBuild project for ${var.name}"
  build_timeout = var.build_timeout
  service_role  = var.service_role_arn
  source_version = var.source_branch

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [ var.vpc_id ] : []

    content {
      vpc_id = var.vpc_id
      subnets = var.vpc_subnets
      security_group_ids = var.vpc_security_group_ids
    }
  }

  artifacts {
    type      = var.artifact_type
    location  = var.artifact_location
    name      = var.artifact_name
    path      = var.artifact_path
    packaging = var.artifact_packaging
    namespace_type         = var.artifact_namespace_type
    override_artifact_name = var.artifact_override_name
  }

  environment {
    compute_type                = var.codebuild_computeType
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode





          }
  source {
    report_build_status  = false
    insecure_ssl         = false
    type                 = var.source_type
    location             = var.source_location
    buildspec            = var.buildspec
    git_clone_depth      = var.source_type == "GITHUB" ? 1 : 0
  }
  }



resource "aws_codebuild_project" "codebuild_pipeline" {
  count = var.artifact_type == "CODEPIPELINE" ? 1 : 0

  name           = var.name
  description    = "CodeBuild project for ${var.name}"
  build_timeout  = var.build_timeout
  service_role   = var.service_role_arn
  source_version = var.source_branch

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [ var.vpc_id ] : []

    content {
      vpc_id = var.vpc_id
      subnets = var.vpc_subnets
      security_group_ids = var.vpc_security_group_ids
    }
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = var.codebuild_computeType
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.privileged_mode
  }

  source {
    report_build_status  = false
    insecure_ssl         = false
    type                 = var.source_type
    location             = var.source_location
    buildspec            = var.buildspec
    git_clone_depth      = var.source_type == "GITHUB" ? 1 : 0
  }

}
resource "aws_codestarnotifications_notification_rule" "codebuild" {
  detail_type    = "BASIC"
  event_type_ids = [
    "codebuild-project-build-state-failed",
    "codebuild-project-build-state-succeeded",
    "codebuild-project-build-state-in-progress",
    "codebuild-project-build-state-stopped"
  ]

  name     = var.name
  resource = var.artifact_type == "CODEPIPELINE" ? aws_codebuild_project.codebuild_pipeline.0.arn : var.artifact_type == "S3" ? aws_codebuild_project.codebuild_s3.0.arn : aws_codebuild_project.codebuild.0.arn


}

resource "aws_codebuild_webhook" "github" {
  project_name = var.artifact_type == "CODEPIPELINE" ? aws_codebuild_project.codebuild_pipeline.0.arn : var.artifact_type == "S3" ? aws_codebuild_project.codebuild_s3.0.arn : aws_codebuild_project.codebuild.0.arn

  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "${var.source_branch}$"
    }

    filter {
      type    = "FILE_PATH"
      pattern = var.source_file_path
    }

    dynamic filter {
      for_each = var.source_file_path_list
      content {
        type    = "FILE_PATH"
        pattern = filter.value
      }
    }
  }

  lifecycle {
    ignore_changes = [
      secret,
      project_name
    ]
  }

  depends_on = [ aws_codestarnotifications_notification_rule.codebuild ]
}