
resource "aws_s3_bucket" "flow_logs_bucket1" {
  bucket = "darkwolf"
}

resource "aws_s3_bucket_policy" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s5" {
  bucket = aws_s3_bucket.flow_logs_bucket1.id
  policy = data.aws_iam_policy_document.policy_which_allow_ALB_to_Push_the_access_log_data_into_s5.json
}

data "aws_iam_policy_document" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s5" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::darkwolf/*"]
  }
}


resource "aws_ec2_transit_gateway" "tgw1" {
  description = "example"
  tags = local.common_tags
}

resource "aws_flow_log" "transit_gateway_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket1.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  transit_gateway_id   = aws_ec2_transit_gateway.tgw1.id
  max_aggregation_interval = 60
}