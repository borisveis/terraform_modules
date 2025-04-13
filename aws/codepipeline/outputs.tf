output "codepipeline_name" {
  description = "The name of the CodePipeline"
  value       = aws_codepipeline.custom_pipeline.name
}

output "codepipeline_arn" {
  description = "The ARN of the CodePipeline"
  value       = aws_codepipeline.custom_pipeline.arn
}
