variable "secrets_json_path" {
  description = "Path to JSON file containing secrets to be added to AWS"
  default     = "./secrets.json"
}

variable "name" {
  description = "Name of the Secrets Manager secret"
}

resource "aws_secretsmanager_secret" "secrets" {
  name = var.name
}

# Actually store the secrets from JSON file into the created secret
resource "aws_secretsmanager_secret_version" "secrets_version" {
  secret_id     = aws_secretsmanager_secret.secrets.id
  secret_string = file(var.secrets_json_path)
}

output "secret_arn" {
  description = "The ARN of the GitHub token stored in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.secrets.arn
}
output "github_token_secret_arn" {
  description = "The ARN of the GitHub token stored in AWS Secrets Manager"
  value       = aws_secretsmanager_secret.secrets.arn
}

