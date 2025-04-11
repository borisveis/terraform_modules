resource "aws_codepipeline" "custom_pipeline" {
  name     = "var.name"
  role_arn = var.role_arn

  artifact_store {
    location = var.artifact_store.location
    type     = var.artifact_store.type
  }

  stage {
    name = "Source"
    action {
      name            = "Source"
      action_type_id  = "AWS::CodePipeline::ActionType"
      run_order       = 1
      configuration   = {
        S3Bucket    = "source-bucket"   # Update with your S3 source configuration
        S3ObjectKey = "source.zip"      # Update with your object key if needed
      }
      output_artifacts = ["source_output"]
      input_artifacts  = []
      role_arn         = var.role_arn
    }
  }

  stage {
    name = "Build"
    action {
      name            = "Build"
      action_type_id  = "AWS::CodePipeline::ActionType"
      run_order       = 1
      configuration   = {
        ProjectName = "build-project"  # Reference to your CodeBuild project
      }
      output_artifacts = ["build_output"]
      input_artifacts  = ["source_output"]
      role_arn         = var.role_arn
    }
  }

  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      action_type_id  = "AWS::CodePipeline::ActionType"
      run_order       = 1
      configuration   = {
        BucketName = "deploy-bucket"  # Reference your S3 bucket or other deploy targets
      }
      output_artifacts = []
      input_artifacts  = ["build_output"]
      role_arn         = var.role_arn
    }
  }

  tags = {
    Name = var.name
  }
}