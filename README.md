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
  source = "git::https://github.com/PlatformStackPulse/tf-atom-s3-bucket-logging-aws.git?ref=v1.0.0"

  # tf-label identity (or pass context = module.this.context)
  namespace = "eg"
  stage     = "prod"
  name      = "app"

  # Required inputs
  bucket_id        = module.bucket.bucket_id      # source bucket to log
  target_bucket_id = module.logs_bucket.bucket_id # destination for access logs

  # Optional (defaults to "logs/")
  target_prefix = "my-app/"
}
```

## Module Documentation

<!-- BEGIN_TF_DOCS -->
### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | git::https://github.com/PlatformStackPulse/tf-label.git | v1.0.0 |

### Resources

| Name | Type |
|------|------|
| [aws_s3_bucket_logging.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | ID (name) of the S3 bucket to enable logging for | `string` | n/a | yes |
| <a name="input_target_bucket_id"></a> [target\_bucket\_id](#input\_target\_bucket\_id) | ID of the bucket where access logs will be stored | `string` | n/a | yes |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes and tags, which are merged. | <pre>object({<br/>    enabled             = optional(bool, true)<br/>    namespace           = optional(string, null)<br/>    tenant              = optional(string, null)<br/>    environment         = optional(string, null)<br/>    stage               = optional(string, null)<br/>    name                = optional(string, null)<br/>    delimiter           = optional(string, null)<br/>    attributes          = optional(list(string), [])<br/>    tags                = optional(map(string), {})<br/>    label_order         = optional(list(string), null)<br/>    regex_replace_chars = optional(string, null)<br/>    id_length_limit     = optional(number, null)<br/>    label_key_case      = optional(string, null)<br/>    label_value_case    = optional(string, null)<br/>    labels_as_tags      = optional(set(string), null)<br/>    descriptor_formats = optional(map(object({<br/>      format = string<br/>      labels = list(string)<br/>    })), {})<br/>  })</pre> | `{}` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>   format = string<br/>   labels = list(string)<br/>}`<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | <pre>map(object({<br/>    format = string<br/>    labels = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources. | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'. | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` to keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>Note: The value of the `name` tag, if included, will be the `id`, not the `name`. | `set(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique. | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_target_prefix"></a> [target\_prefix](#input\_target\_prefix) | Prefix for log object keys (e.g. 'logs/') | `string` | `"logs/"` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element. A customer identifier, indicating who this instance of a resource is for. | `string` | `null` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_enabled"></a> [enabled](#output\_enabled) | Whether the module is enabled. |
| <a name="output_id"></a> [id](#output\_id) | ID of the logging configuration |
| <a name="output_target_bucket_id"></a> [target\_bucket\_id](#output\_target\_bucket\_id) | ID of the target logging bucket |
<!-- END_TF_DOCS -->

## Tests

Unit tests run against a `mock_provider "aws"` at `plan` time — no AWS credentials
or real resources are required. They assert only on plan-known values (the
`enabled` flag, planned resource count, and input pass-throughs).

| Test file | What it verifies |
|-----------|------------------|
| `tests/unit/main_test.tftest.hcl` | Resource is planned when enabled; `target_prefix` is threaded through; disabled produces zero resources and a `null` `id` output |

Run them locally:

```bash
terraform init -backend=false
terraform test -test-directory=tests/unit
# or:
make test-unit
```
