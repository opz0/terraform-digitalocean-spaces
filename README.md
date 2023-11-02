# terraform-digitalocean-spaces
## Terraform-Digitalocean-Spaces

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Examples](#examples)
- [License](#license)

## Introduction

This module creates a DigitalOcean Spaces object storage bucket with customizable settings. You can use this module to provision a Spaces bucket for your infrastructure.

## Usage

- # complete
You can use this module in your Terraform configuration like this:

```hcl
module "spaces" {
  source        = "git::https://github.com/opz0/terraform-digitalocean-spaces.git?ref=v1.0.0"
  name          = "spaced"
  environment   = "test"
  acl           = "private"
  force_destroy = false
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
Ensure you replace YOUR_DIGITALOCEAN_API_TOKEN with your actual DigitalOcean API token.

- # default
You can use this module in your Terraform configuration like this:

```hcl
module "spaces" {
  source        = "git::https://github.com/opz0/terraform-digitalocean-spaces.git?ref=v1.0.0"
  name          = "my-space"
  environment   = "production"
  acl           = "public-read"
  force_destroy = false
  region        = "nyc3"
}

output "my_space_id" {
  value = module.spaces.space_id
}
```
Please ensure you specify the correct 'source' path for the module.

## Module Inputs
Here are the available configuration options for the module:

- 'name': The name of the DigitalOcean Spaces bucket.
- 'environment': The environment for the Spaces bucket (e.g., "test").
- 'acl': The access control list for the bucket (e.g., "private").
- 'force_destroy': Set to `true` to allow the bucket to be destroyed even if it contains objects. Set to false to prevent accidental deletion.
- 'region': The DigitalOcean data center region where the Spaces bucket should be created.
- 'cors_rule': allows you to define CORS (Cross-Origin Resource Sharing) rules for the Spaces bucket. You can configure allowed headers, methods, origins, expose headers, and max age.
- 'lifecycle_rule': lets you configure lifecycle rules for the Spaces bucket. This includes enabling or disabling the rule, specifying the number of days to abort incomplete multipart uploads, and setting expiration rules for objects. You can also configure noncurrent version expiration.
- 'policy': enables you to define a bucket policy for the Spaces bucket. This is a JSON-encoded IAM policy that controls access to the bucket based on IP addresses and actions allowed or denied.


## Module Outputs
- 'space_id': The unique identifier for the created DigitalOcean Space.
- 'space_name': The name of the created DigitalOcean Space.
- 'space_endpoint': The URL endpoint for the DigitalOcean Space.

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## License
This Terraform module is provided under the '[License Name]' License. Please see the [LICENSE](https://github.com/opz0/terraform-digitalocean-spaces/blob/readme/LICENSE) file for more details.

## Author
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.
