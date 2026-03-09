resource "aws_db_instance" "task1_db" {
  allocated_storage = 10
  db_name           = "task1_db"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"

  multi_az = true

  username = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
  password = jsondecode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]

  skip_final_snapshot = true
  tags = {
    Name = "task1-db-instance"
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "task1-db-subnet-group"
  subnet_ids = data.terraform_remote_state.core.outputs.database_subnet_ids

  tags = { Name = "task1-db-subnet-group" }
}