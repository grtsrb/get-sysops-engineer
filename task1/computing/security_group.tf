resource "aws_security_group" "database" {
  name        = "task1-db-sg"
  description = "Security group for RDS database"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id

  ingress {
    description     = "Allow PostgreSQL from EC2 in public subnets"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.instance.id]
  }

  tags = { Name = "task1-db-sg" }
}

resource "aws_security_group" "instance" {
  name        = "task1-ec2-sg"
  description = "Security group for EC2 instances"
  vpc_id      = data.terraform_remote_state.core.outputs.vpc_id

  ingress {
    description = "Allow SSH from my WSL"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip_address}/32"]
  }
  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "task1-ec2-sg"
  }
}