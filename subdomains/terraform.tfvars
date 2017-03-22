terragrunt = {
  # Configure Terragrunt to use DynamoDB for locking
  lock {
    backend = "dynamodb"

    config {
      state_file_id = "apidocs/${path_relative_to_include()}.tfstate"
      aws_region    = "${get_env("TF_VAR_AWS_REGION", "eu-central-1")}"
      table_name    = "terragrunt_locks"
      aws_profile   = "${get_env("TF_VAR_AWS_PROFILE", "")}"
    }
  }

  # Configure Terragrunt to automatically store tfstate files in an S3 bucket
  remote_state {
    backend = "s3"

    config {
      encrypt = "true"
      bucket  = "${get_env("TF_VAR_BUCKET_NAME", "d2d-playground-infrastructure")}"
      key     = "apidocs/${path_relative_to_include()}.tfstate"
      region  = "${get_env("TF_VAR_AWS_REGION", "eu-central-1")}"
      profile = "${get_env("TF_VAR_AWS_PROFILE", "")}"
    }
  }
}
