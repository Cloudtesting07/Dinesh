# Import the existing ALB
resource "aws_lb" "Alb1" {
  name                     = "Alb1" # Replace with the name of your existing ALB
  internal                 = false
  load_balancer_type       = "application"
  enable_deletion_protection = false
  subnets            = ["subnet-04c9f5d12632082ec", "subnet-0117bf1bc67f24d8a"]


  
  # Add other ALB attributes as needed
  # ...
   # Enable access logs
   access_logs {
     bucket  = aws_s3_bucket.example_flow_logs.id
     prefix  = "logs/accesslogs"
     enabled = true
   }
   depends_on = [ aws_s3_bucket.example_flow_logs ]
 }

resource "aws_lb" "Alb2" {
  name                     = "Alb2" # Replace with the name of your existing ALB
  internal                 = false
  load_balancer_type       = "application"
  enable_deletion_protection = false
  subnets            = ["subnet-020f865b746e1bd9b", "subnet-08321653deabc674d"]


   # Enable access logs
   access_logs {
     bucket  = aws_s3_bucket.example_flow_logs.id
     prefix  = "logs/accesslogs"
     enabled = true
   }
     depends_on = [ aws_s3_bucket.example_flow_logs ]
 }


 resource "aws_s3_bucket" "example_flow_logs" {
   bucket = "dineshroman" # Replace with a unique bucket name
   acl    = "private"    
 #   region = "us-east-1"         # Adjust ACL as needed
 }


resource "aws_s3_bucket_policy" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s3" {
  bucket = aws_s3_bucket.example_flow_logs.id
  policy = data.aws_iam_policy_document.policy_which_allow_ALB_to_Push_the_access_log_data_into_s3.json
}

data "aws_iam_policy_document" "policy_which_allow_ALB_to_Push_the_access_log_data_into_s3" {
  version = "2012-10-17"

  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::127311923021:root"]
    }

    actions = ["s3:PutObject"]

    resources = ["arn:aws:s3:::dineshroman/*"]
  }
}


