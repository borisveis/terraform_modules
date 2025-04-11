variable "secrets_json_path" {
    description = "path to json file containing secrets to be added to AWS"
    default = "./secrets.json"
}
variable "name" {
  description = "NAme of secrets manager"
}
resource "aws_secretsmanager_secret" "secrets" {
  name = var.name
}
