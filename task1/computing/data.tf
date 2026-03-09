data "terraform_remote_state" "core" {
  backend = "s3"
  config = {
    bucket = "get-sysops-case-study-remote-state"
    key    = "task1/terraform.tfstate"
    region = var.region
  }
}

data "aws_secretsmanager_secret" "db_secrets" {
  name = "task1/db/credentials"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.db_secrets.id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "http" "public_ip" {
  url = "https://checkip.amazonaws.com/"
}