variable "bucket_id" {
  description = "ID (name) of the S3 bucket to enable logging for"
  type        = string
}

variable "target_bucket_id" {
  description = "ID of the bucket where access logs will be stored"
  type        = string
}

variable "target_prefix" {
  description = "Prefix for log object keys (e.g. 'logs/')"
  type        = string
  default     = "logs/"
}
