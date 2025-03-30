variable "region" {
  type = string
  default = "us-west-1"
}
variable "bucket_name" {
  type = string
  default = "BorisVdefault_name"
}
variable "acl" {
  type = string
  default = "private"
}
variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {
    Environment = "Dev"
    Owner       = "YourName"
  }
}