output "codepipeline_name" {
  description = "The name of the CodePipeline"
  value       = aws_codepipeline.code_pipeline.name
}

output "codepipeline_arn" {
  description = "The ARN of the CodePipeline"
  value       = aws_codepipeline.code_pipeline.arn
}