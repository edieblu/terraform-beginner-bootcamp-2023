resource "aws_s3_bucket" "website_bucket" {
  # we'll be using the auto
  #bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
}


resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_file" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "index.html"
  content_type = "text/html"
  source       = "${var.public_path}/index.html"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes       = [etag]
  }

  etag = filemd5("${var.public_path}/index.html")
}


resource "aws_s3_object" "error_file" {
  bucket       = aws_s3_bucket.website_bucket.bucket
  key          = "error.html"
  content_type = "text/html"
  source       = "${var.public_path}/error.html"
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes       = [etag]
  }

  etag = filemd5("${var.public_path}/error.html")
}

resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${var.public_path}/assets", "*.{jpg,jpeg,png,gif}")
  bucket   = aws_s3_bucket.website_bucket.bucket
  key      = "assets/${each.key}"
  source   = "${var.public_path}/assets/${each.key}"
  etag     = filemd5("${var.public_path}/assets/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes       = [etag]
  }
}
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.website_bucket.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Sid"    = "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "cloudfront.amazonaws.com"
      },
      "Action"   = "s3:GetObject",
      "Resource" = "arn:aws:s3:::${aws_s3_bucket.website_bucket.id}/*",
      "Condition" = {
        "StringEquals" = {
          "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
        }
      }
    }
  })
}

resource "terraform_data" "content_version" {
  input = var.content_version
}
