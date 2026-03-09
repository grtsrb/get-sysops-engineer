resource "aws_db_instance" "name" {
  allocated_storage = 10
  db_name           = "task1-db-instance"
  engine            = "postgres"
  engine_version    = "17.0"
  instance_class    = "db.t3.micro"

  multi_az = true

  username = jsonencode(data.aws_secretsmanager_secret_version.current.secret_string)["username"]
  password = jsonencode(data.aws_secretsmanager_secret_version.current.secret_string)["password"]

  db_subnet_group_name   = aws_db_subnet_group.database.name
  vpc_security_group_ids = [aws_security_group.database.id]

  tags = {
    Name = "task1-db-instance"
  }
}

resource "aws_db_subnet_group" "database" {
  name       = "task1-db-subnet-group"
  subnet_ids = [for s in aws_subnet.database : s.id]

  tags = { Name = "task1-db-subnet-group" }
}