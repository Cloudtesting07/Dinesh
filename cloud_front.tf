
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "My CloudFront Origin Access Identity"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "darkruler"
  # Add other S3 bucket configuration here
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.my_bucket.bucket_regional_domain_name
    origin_id   = "S3-my-bucket-origin"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  default_cache_behavior {
    target_origin_id = "S3-my-bucket-origin"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  ordered_cache_behavior {
    path_pattern     = "/images/*"
    target_origin_id = "S3-my-bucket-origin"

    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    min_ttl = 0
    default_ttl = 3600
    max_ttl = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

web_acl_id = aws_wafv2_web_acl.example1.arn

 logging_config {
    bucket         = aws_s3_bucket.my_bucket.bucket_domain_name
    include_cookies = false
    prefix         = "cloudfront-logs/"  # Adjust the log prefix as needed
  }


}


resource "aws_s3_bucket_policy" "new_policy" {
  bucket = aws_s3_bucket.my_bucket.id
  policy = data.aws_iam_policy_document.new_policy.json
}

data "aws_iam_policy_document" "new_policy" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::darkruler/*"]
  }
}


