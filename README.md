# tf-atom-s3-bucket-logging-aws

[![CI](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws/actions/workflows/ci.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws/actions/workflows/ci.yml)
[![Release](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws/actions/workflows/auto-release.yml/badge.svg)](https://github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws/actions/workflows/auto-release.yml)

---

## Purpose

Configures server access logging for an S3 bucket, writing access logs to a designated target bucket with a configurable prefix. Essential for auditing and compliance.

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│           Molecule Layer                                │
│  ┌──────────────┐    ┌────────────────────────┐        │
│  │ s3-bucket    │───▶│ THIS MODULE            │        │
│  │ (source)     │    │ logging                │        │
│  └──────────────┘    │ (access logs → target) │        │
│                      └────────┬───────────────┘        │
│                               │                        │
│                               ▼                        │
│                      ┌────────────────────┐            │
│                      │ s3-bucket (target) │            │
│                      │ (logs destination) │            │
│                      └────────────────────┘            │
└─────────────────────────────────────────────────────────┘
```

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `aws_s3_bucket_logging` resource | Bucket creation (→ `tf-atom-s3-bucket-aws`) |
| Target bucket and prefix | Target bucket policy (→ `tf-atom-s3-bucket-policy-aws`) |
| Conditional creation (`enabled`) | CloudTrail data events |

## Features

- **Single-resource atom** — one `aws_s3_bucket_logging`
- **Default prefix** — logs stored under `logs/` by default
- **Configurable target** — logs to any bucket
- **Tested** — unit tests for config, disabled, and default prefix

## Usage

```hcl
module "bucket_logging" {
  source = "github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws?ref=v1.0.0"

  context          = module.this.context
  bucket_id        = module.bucket.bucket_id
  target_bucket_id = module.logs_bucket.bucket_id
  target_prefix    = "my-app/"
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
