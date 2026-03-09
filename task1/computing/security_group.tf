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

resource "aws_security_group" "instance" {
  name        = "task1-ec2-sg" # Added quotes
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.main.id

  # Rule 1: Restricted SSH (No '=' used for blocks)
  ingress {
    description = "Allow SSH from my WSL"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
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