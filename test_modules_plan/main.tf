module "codebuild" {
  # source = "../aws/codebuild"
  # source = "git@github.com:borisveis/terraform_modules.git//aws/codebuild"
  source = "../aws/codebuild"
  name = "test"
}

module "s3" {
  source = "../aws/s3"

}