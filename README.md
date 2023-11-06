# terraform-digitalocean-spaces
# DigitalOcean Terraform Configuration

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Examples](#examples)
- [License](#license)

## Introduction
This Terraform configuration is designed to create and manage a DigitalOcean spaces.

## Usage
To use this module, you should have Terraform installed and configured for DIGITALOCEAN. This module provides the necessary Terraform configuration for creating DIGITALOCEAN resources, and you can customize the inputs as needed. Below is an example of how to use this module:


- # database-spaces
You can use this module in your Terraform configuration like this:
- # complete example
```hcl

module "spaces" {
  source        = "git::https://github.com/opz0/terraform-digitalocean-spaces.git?ref=v1.0.0"
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


- # default example
You can use this module in your Terraform configuration like this:
```hcl
module "spaces" {
  source        = "git::https://github.com/opz0/terraform-digitalocean-spaces.git?ref=v1.0.0"
  name          = "spaces"
  environment   = "test"
  acl           = "private"
  force_destroy = false
  region        = "nyc3"
}
```
This example demonstrates how to create various DIGITALOCEAN resources using the provided modules. Adjust the input values to suit your specific requirements.


## Module Inputs

- 'source': The source of the spaces module.
- 'name' (string): A name for the spaces.
- 'environment' (string): The environment in which the spaces rules will be applied.
- 'region':The region where the bucket resides .
- 'acl': Canned ACL applied on bucket creation.
- 'force_destroy' : Unless true, the bucket will only be destroyed if empty (Defaults to false).
- 'lifecycle_rule' :  A configuration of object lifecycle management (documented below).

## Module Outputs

This module does not produce any outputs. It is primarily used for labeling resources within your Terraform configuration.

- 'urn':  The uniform resource name for the bucket.
- 'name' : The name of the bucket.
- 'bucket_domain_name' : The FQDN of the bucket (e.g. bucket-name.nyc3.digitaloceanspaces.com).

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## License
This Terraform module is provided under the '[License Name]' License. Please see the [LICENSE](https://github.com/opz0/terraform-digitalocean-spaces/blob/readme/LICENSE) file for more details.

## Author
Your Name
Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.