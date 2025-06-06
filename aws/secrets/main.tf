resource "aws_secretsmanager_secret" "github_token" {
  name        = var.name
  description = "GitHub token for CI/CD pipeline"
}

resource "aws_secretsmanager_secret_version" "github_token_value" {
  secret_id     = aws_secretsmanager_secret.github_token.id
  secret_string = file(var.secrets_json_path)
}


