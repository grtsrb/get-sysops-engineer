data "aws_secretsmanager_secret" "db_secrets" {
  name = "get-case-study-task1-db-secrets"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db_secrets.id
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "http" "public_ip" {
  url = "https://checkip.amazonaws.com/"
}