output "urn" {
  value       = join("", digitalocean_spaces_bucket.spaces2[*].urn)
  description = " The uniform resource name (URN) for the VPC."
}

output "name" {
  value       = join("", digitalocean_spaces_bucket.spaces2[*].name)
  description = "The date and time of when the VPC was created."
}

output "bucket_domain_name" {
  value       = join("", digitalocean_spaces_bucket.spaces2[*].bucket_domain_name)
  description = "The date and time of when the VPC was created."
}
