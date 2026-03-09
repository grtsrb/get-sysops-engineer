module "sns_topic" {
  source  = "terraform-aws-modules/sns/aws"
  version = "v7.0.0"

  name = "task2-daily-notification"
}

resource "aws_sns_topic_policy" "lambda_publish_policy" {
  arn = module.sns_topic.topic_arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    effect  = "Allow"
    actions = ["sns:Publish"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    resources = [module.sns_topic.topic_arn]

    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [module.task2_helloworld.lambda_function_arn]
    }
  }
}