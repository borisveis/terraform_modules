variable "bucket_name" {
  type    = string
  default = "default_name"
}
variable "acl" {
  type    = string
  default = "private"
}
variable "force_destroy" {
  type    = bool
  default = false
}
variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default = {
    Environment = "Dev"
    Owner       = "YourName"

  }
}
