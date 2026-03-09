resource "aws_iam_role" "ec2_sm_role" {
  name = "task1-ec2-secrets-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "task1-ec2-instance-profile"
  role = aws_iam_role.ec2_sm_role.name
}


resource "aws_iam_role_policy" "ec2_secrets_only" {
  name = "Task1-Secrets-Access"
  role = aws_iam_role.ec2_sm_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = data.aws_secretsmanager_secret.db_secrets.arn
      }
    ]
  })
}