output "bucket_name" {
  value = module.s3.bucket_name
}

output "website_endpoint" {
  value = module.s3.website_endpoint
}

output "api_endpoint" {
  value = module.api.api_endpoint
}
