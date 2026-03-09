resource "aws_instance" "task1-web" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public["1a"].id
  vpc_security_group_ids = [aws_security_group.compute.id]

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  user_data = <<-EOF
              #!/bin/bash
              # 1. Update packages
              dnf update -y

              # 2. Install Apache
              dnf install -y httpd
              systemctl start httpd
              systemctl enable httpd

              # 3. Install PostgreSQL 16 Client
              dnf install -y postgresql16 jq aws-

              DB_HOST=${aws_db_instance.task1-db.address}

              until nc -zv $DB_HOST 5432; do
                echo "Waiting for PostgreSQL to be available..."
                sleep 5
              done

              # 4. Fetch Credentials from Secrets Manager
              SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id ${data.aws_secretsmanager_secret.db_credentials.id} --query SecretString --output text --region ${var.region})
              
              # 5. Extract user and pass using JQ
              DB_USER=$(echo $SECRET_JSON | jq -r .username)
              export PGPASSWORD=$(echo $SECRET_JSON | jq -r .password)

              psql -h $DB_HOST -U $DB_USER -d postgres <<SQL
              CREATE TABLE IF NOT EXISTS inventory (
                  id SERIAL PRIMARY KEY,
                  item_name VARCHAR(100) NOT NULL,
                  category VARCHAR(50),
                  price NUMERIC(10, 2),
                  stock_count INTEGER,
                  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
              );

              INSERT INTO inventory (item_name, category, price, stock_count) VALUES 
              ('Lenovo Thinkpad', 'Electronics', 1200.50, 10),
              ('Logitech MX Master 3s', 'Peripherals', 80.00, 50),
              ('Logitech MX Keys', 'Peripherals', 110.00, 15)
              ON CONFLICT DO NOTHING;
              SQL
              # 6. Clean up
              unset PGPASSWORD              

              # 7. Create simple landing page
              echo "<h1>Amazon Linux 2023 - Task 1</h1>" > /var/www/html/index.html
              EOF

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  tags = {
    Name = "task1-al2023-web"
  }
}

resource "aws_eip" "web_static_ip" {
  domain = "vpc"

  tags = {
    Name = "task1-web-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.task1-web.id
  allocation_id = aws_eip.web_static_ip.id
}