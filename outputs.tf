output "bucket_name" {
  value       = module.home_one_hosting.bucket_name
  description = "name of the bucket"
}

output "S3_bucket_endpoint" {
  value       = module.home_one_hosting.bucket_endpoint
  description = "S3 static website hosting endpoint"
}

output "cloudfront_url" {
  value       = module.home_one_hosting.domain_name
  description = "CloudFront distribution url"
}
