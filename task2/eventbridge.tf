module "eventbridge_cron" {
  source  = "terraform-aws-modules/eventbridge/aws"
  version = "v4.3.0"

  create_bus = false

  rules = {
    crons = {
      description         = "Trigger Hello World lambda each day at 1 am"
      schedule_expression = "cron(0 1 * * ? *)"
    }
  }

  targets = {
    crons = [
      {
        name  = "hello-world-lambda-cron"
        arn   = module.task2_helloworld.lambda_function_arn
        input = jsonencode({ "job" : "cron-by-rate" })
      }
    ]
  }
}