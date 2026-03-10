module "task2_helloworld" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "v7.21.1"

  function_name = "task2-lambda"
  description   = "Lamba function that is triggered each morning at 1 am to send a message to an SNS topic"
  handler       = "hello_world.lambda_handler"
  runtime       = "python3.12"
  publish       = true
  source_path = "${path.module}/lambda/hello_world"

  environment_variables = {
    SNS_TOPIC_ARN = module.sns_topic.topic_arn
  }

  cloudwatch_logs_log_group_class   = "STANDARD"
  cloudwatch_logs_retention_in_days = 30

  allowed_triggers = {
    AllowExecutionFromEventBridge = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge_cron.eventbridge_rule_arns["crons"]
    }
  }

  attach_policy_statements = true
  policy_statements = {
    sns_publish = {
      effect    = "Allow"
      actions   = ["sns:Publish"]
      resources = [module.sns_topic.topic_arn]
    }
  }

  timeouts = {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}