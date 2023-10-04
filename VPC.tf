resource "aws_s3_bucket" "flow_logs_bucket" {
  bucket = "darkruler07"
}

resource "aws_s3_bucket_policy" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s4" {
  bucket = aws_s3_bucket.flow_logs_bucket.id
  policy = data.aws_iam_policy_document.policy_which_allow_ALB_to_Push_the_access_log_data_into_s4.json
}

data "aws_iam_policy_document" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s4" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::darkruler07/*"]
  }
}


# Import Existing VPCs
resource "aws_vpc" "vpc2" {
  tags = local.common_tags
}


resource "aws_vpc" "vpc3" {
  tags = local.common_tags
}

resource "aws_vpc" "vpc4" {
  tags = local.common_tags
}

# Create Flow Logs for Existing VPCs

resource "aws_flow_log" "vpc2_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc2.id
 
}

resource "aws_flow_log" "vpc3_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc3.id

}

resource "aws_flow_log" "vpc4_flow_log" {
  log_destination      = aws_s3_bucket.flow_logs_bucket.arn
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc4.id

}

