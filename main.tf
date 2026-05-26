# -----------------------------------------------------
# Atom: S3 Bucket Logging
# Configures server access logging for an S3 bucket.
# -----------------------------------------------------
resource "aws_s3_bucket_logging" "this" {
  count = module.this.enabled ? 1 : 0

  bucket = var.bucket_id

  target_bucket = var.target_bucket_id
  target_prefix = var.target_prefix
}
