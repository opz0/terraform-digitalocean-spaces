module "labels" {
  source      = "git::https://github.com/cypik/terraform-digitalocean-labels.git?ref=v1.0.0"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order #
}

resource "digitalocean_spaces_bucket" "spaces2" {
  count         = var.enabled ? 1 : 0
  name          = module.labels.id
  region        = var.region
  acl           = var.acl
  force_destroy = var.force_destroy

  dynamic "cors_rule" {
    for_each = var.cors_rule == null ? [] : var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      enabled                                = lookup(lifecycle_rule.value, "enabled", false)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      dynamic "expiration" {
        for_each = var.expiration
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", false)
        }
      }
      noncurrent_version_expiration {
        days = lookup(lifecycle_rule.value, "noncurrent_version_expiration_days", null)
      }
    }
  }
  versioning {
    enabled = var.versioning
  }
}

resource "digitalocean_spaces_bucket_policy" "foobar" {
  count  = var.enabled && var.policy != null ? 1 : 0
  region = join("", digitalocean_spaces_bucket.spaces2[*].region)
  bucket = join("", digitalocean_spaces_bucket.spaces2[*].name)
  policy = var.policy
}
