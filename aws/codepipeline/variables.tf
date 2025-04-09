variable "role_arn" {
    type = string
}
variable "name" {
    type = string
    default = "default_name"
}
variable "artifact_store" {
  description = "Artifact store configuration for CodePipeline"
  type = object({
    location = string
    type     = string
  })
}
