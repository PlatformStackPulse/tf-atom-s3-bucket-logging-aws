mock_provider "aws" {}

run "creates_logging_config" {
  variables {
    name             = "test"
    environment      = "dev"
    namespace        = "unit"
    bucket_id        = "my-source-bucket"
    target_bucket_id = "my-logs-bucket"
    target_prefix    = "access-logs/"
  }

  assert {
    condition     = aws_s3_bucket_logging.this[0].target_bucket == "my-logs-bucket"
    error_message = "Should log to the specified target bucket"
  }

  assert {
    condition     = aws_s3_bucket_logging.this[0].target_prefix == "access-logs/"
    error_message = "Should use the specified target prefix"
  }
}

run "creates_nothing_when_disabled" {
  variables {
    name             = "test"
    environment      = "dev"
    namespace        = "unit"
    enabled          = false
    bucket_id        = "my-source-bucket"
    target_bucket_id = "my-logs-bucket"
  }

  assert {
    condition     = length(aws_s3_bucket_logging.this) == 0
    error_message = "No resource should be created when disabled"
  }
}

run "uses_default_prefix" {
  variables {
    name             = "test"
    environment      = "dev"
    namespace        = "unit"
    bucket_id        = "my-source-bucket"
    target_bucket_id = "my-logs-bucket"
  }

  assert {
    condition     = aws_s3_bucket_logging.this[0].target_prefix == "logs/"
    error_message = "Should default to 'logs/' prefix"
  }
}
