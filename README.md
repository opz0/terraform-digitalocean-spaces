# Terraform-digitalocean-spaces
# Terraform digitalocean Cloud spaces Module.

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#examples)
- [Author](#author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform configuration is designed to create and manage a DigitalOcean spaces.

## Usage
To use this module, you should have Terraform installed and configured for DIGITALOCEAN. This module provides the necessary Terraform configuration for creating DIGITALOCEAN resources, and you can customize the inputs as needed. Below is an example of how to use this module:


# Example: Complete
You can use this module in your Terraform configuration like this:
```hcl

module "spaces" {
  source        = "cypik/spaces/digitalocean"
  version       = "1.0.2"
  name          = "spaced"
  environment   = "test"
  acl           = "private"
  region        = "nyc3"

  cors_rule = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["PUT", "POST"],
      allowed_origins = ["https://www.example.com"],
      expose_headers  = ["ETag"],
      max_age_seconds = 3000
    }
  ]

  lifecycle_rule = [
    {
      enabled                                = true
      abort_incomplete_multipart_upload_days = 25
      expiration = [
        {
          date                         = "2029-09-28"
          days                         = 65
          expired_object_delete_marker = true
        }
      ]
      noncurrent_version_expiration_days = 15

    }
  ]

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "IPAllow",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::spaces-name",
          "arn:aws:s3:::spaces-name/*"
        ],
        "Condition" : {
          "NotIpAddress" : {
            "aws:SourceIp" : "0.0.0.0/0"
          }
        }
      }
    ]
  })
}
```
Please replace "your_database_spaces_id" with the actual ID of your DigitalOcean database spaces, and adjust the spaces rules as needed.


# Example: Default
You can use this module in your Terraform configuration like this:
```hcl
module "spaces" {
  source        = "cypik/spaces/digitalocean"
  version       = "1.0.2"
  name          = "spaces"
  environment   = "test"
  acl           = "private"
  force_destroy = false
  region        = "nyc3"
}
```

This example demonstrates how to create various DIGITALOCEAN resources using the provided modules. Adjust the input values to suit your specific requirements.


## Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/cypik/terraform-digitalocean-spaces/blob/master/example) directory within this repository.

## Author
Your Name
Replace **MIT** and **cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This Terraform module is provided under the **MIT** License. Please see the [LICENSE](https://github.com/cypik/terraform-digitalocean-spaces/blob/master/LICENSE) file for more details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.5 |
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | >= 2.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | >= 2.40.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/digitalocean | 1.0.2 |

## Resources

| Name | Type |
|------|------|
| [digitalocean_spaces_bucket.spaces2](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/spaces_bucket) | resource |
| [digitalocean_spaces_bucket_cors_configuration.cors_config](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/spaces_bucket_cors_configuration) | resource |
| [digitalocean_spaces_bucket_policy.foobar](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/spaces_bucket_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | Canned ACL applied on bucket creation (private or public-read). | `string` | `null` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | CORS Configuration specification for this bucket | <pre>list(object({<br>    allowed_headers = list(string)<br>    allowed_methods = list(string)<br>    allowed_origins = list(string)<br>    expose_headers  = list(string)<br>    max_age_seconds = number<br>  }))</pre> | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether to create the resources. Set to `false` to prevent the module from creating any resources. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_expiration"></a> [expiration](#input\_expiration) | Specifies a time period after which applicable objects expire (documented below). | `list(any)` | `[]` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Unless true, the bucket will only be destroyed if empty (Defaults to false). | `bool` | `false` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `cypik`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_lifecycle_rule"></a> [lifecycle\_rule](#input\_lifecycle\_rule) | A configuration of object lifecycle management (documented below). | `list(any)` | `[]` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'cypik' | `string` | `"cypik"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The text of the policy. | `any` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | The region to create spaces. | `string` | `""` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | (Optional) A state of versioning (documented below). | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The date and time of when the VPC was created. |
| <a name="output_name"></a> [name](#output\_name) | The date and time of when the VPC was created. |
| <a name="output_urn"></a> [urn](#output\_urn) | The uniform resource name (URN) for the VPC. |
<!-- END_TF_DOCS -->
