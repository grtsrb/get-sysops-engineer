# ======================= SECRETS =====================
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%^&*()-_=+[]{}|:,.<>?"
}

resource "aws_secretsmanager_secret" "db_credentials" {
  name = "task1/db/credentials"
}

resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = "nikola"
    password = random_password.db_password.result
  })
}