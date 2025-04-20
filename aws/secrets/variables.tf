variable "secrets_json_path" {
  description = "Path to JSON file containing secrets to be added to AWS"
  default     = "./secrets.json"
}

variable "name" {
  description = "Name of the Secrets Manager secret"
}
