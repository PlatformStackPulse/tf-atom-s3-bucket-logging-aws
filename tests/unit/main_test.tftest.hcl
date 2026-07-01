mock_provider "aws" {}

# Top-level variables shared by all runs. Provides the tf-label required
# identity inputs plus this module's own required inputs with valid samples.
variables {
  namespace        = "eg"
  stage            = "test"
  name             = "thing"
  bucket_id        = "eg-test-thing-source"
  target_bucket_id = "eg-test-thing-logs"
  target_prefix    = "access-logs/"
}

# When enabled (default), the logging resource is created and the
# plan-known outputs/inputs resolve as expected.
run "creates_when_enabled" {
  command = plan

  assert {
    condition     = output.enabled == true
    error_message = "Module should report enabled = true by default"
  }

  assert {
    condition     = length(aws_s3_bucket_logging.this) == 1
    error_message = "Exactly one aws_s3_bucket_logging resource should be planned when enabled"
  }

  assert {
    condition     = output.target_bucket_id == "eg-test-thing-logs"
    error_message = "target_bucket_id output should pass through the input value"
  }
}

# The target_prefix input is threaded to the resource.
run "sets_target_prefix" {
  command = plan

  assert {
    condition     = aws_s3_bucket_logging.this[0].target_prefix == "access-logs/"
    error_message = "Resource target_prefix should match the configured input"
  }
}

# When disabled, no resource is created and the id output is null.
run "disabled_creates_nothing" {
  command = plan

  variables {
    enabled = false
  }

  assert {
    condition     = output.enabled == false
    error_message = "Module should report enabled = false when disabled"
  }

  assert {
    condition     = length(aws_s3_bucket_logging.this) == 0
    error_message = "No aws_s3_bucket_logging resource should be planned when disabled"
  }

  assert {
    condition     = output.id == null
    error_message = "id output should be null when the module is disabled"
  }
}
