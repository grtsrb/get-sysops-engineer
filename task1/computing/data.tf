data "aws_secretsmanager_secret" "db_secrets" {
  name = "get-case-study-task1-db-secrets"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db_secrets.id
}

