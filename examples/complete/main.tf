provider "aws" {
  region = "eu-west-2"
}

module "s3_logging" {
  source = "../../"

  namespace   = "psp"
  environment = "dev"
  name        = "assets"

  bucket_id        = "psp-dev-assets"
  target_bucket_id = "psp-dev-access-logs"
  target_prefix    = "assets/"
}

output "id" {
  value = module.s3_logging.id
}
