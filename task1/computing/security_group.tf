resource "aws_security_group" "database" {
  name        = "task1-db-sg"
  description = "Security group for RDS database"
  vpc_id      = aws_vpc.main.id

  ingress = {
    description = "Allow PostgreSQL from EC2 in public subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [for s in aws_subnet.public : s.cidr_block]
  }

  tags = { Name = "task1-db-sg" }
}