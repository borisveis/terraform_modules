data "aws_region" "current" {}

resource "aws_codebuild_project" "codebuild" {
  count = var.artifact_type == "NO_ARTIFACTS" ? 1 : 0

  name          = var.name
  description   = "CodeBuild project for ${var.name}"
  build_timeout = var.build_timeout
  service_role  = var.service_role_arn
  source_version = var.source_branch

  dynamic "vpc_config" {
    for_each = length(var.vpc_id) > 0 ? [var.vpc_id] : []

    content {
      vpc_id               = var.vpc_id
      subnets              = var.vpc_subnets
      security_group_ids   = var.vpc_security_group_ids
    }
  }

  artifacts {
    type = var.artifact_type == "NO_ARTIFACTS" ? "NO_ARTIFACTS" : var.artifact_type
    location  = var.artifact_location
    name      = var.artifact_name
    path      = var.artifact_path
    packaging = var.artifact_packaging
    namespace_type         = var.artifact_namespace_type
    override_artifact_name = var.art
