output "id" {
  value = var.artifact_type == "CODEPIPELINE" ? aws_codebuild_project.codebuild_pipeline.0.id : var.artifact_type == "S3" ? aws_codebuild_project.codebuild_s3.0.id : aws_codebuild_project.codebuild.0.id
}
output "arn" {
  value = var.artifact_type == "CODEPIPELINE" ? aws_codebuild_project.codebuild_pipeline.0.arn : var.artifact_type == "S3" ? aws_codebuild_project.codebuild_s3.0.arn : aws_codebuild_project.codebuild.0.arn
}