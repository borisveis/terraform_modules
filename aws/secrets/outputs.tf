output "github_token_secret_arn" {
  description = "The ARN of the GitHub token stored in AWS Secrets Manager"
  value = aws_secretsmanager_secret.github_token.arn
  # value       = aws_secretsmanager_secret.secrets.arn
}