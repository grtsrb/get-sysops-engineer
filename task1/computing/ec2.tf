resource "aws_instance" "task1_web" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"

  subnet_id              = data.terraform_remote_state.core.outputs.public_subnet_ids[0]
  vpc_security_group_ids = [aws_security_group.instance.id]

  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  depends_on = [aws_db_instance.task1_db]
  user_data  = <<-EOF
              #!/bin/bash
              # 1. Update and installation of packages
              yum update -y
              amazon-linux-extras enable php8.2 postgresql14
              yum install -y httpd php php-pgsql jq nc postgresql

              systemctl start httpd
              systemctl enable httpd

              # 2. Variables
              DB_HOST="${aws_db_instance.task1_db.address}"
              DB_NAME="postgres"

              # 3. Get credentials 
              SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id ${data.aws_secretsmanager_secret.db_secrets.id} --query SecretString --output text --region ${var.region})
              DB_USER=$(echo $SECRET_JSON | jq -r .username)
              DB_PASS=$(echo $SECRET_JSON | jq -r .password)

              # 4. Wait for RDS to be up, create table and fill it with data 
              export PGPASSWORD=$DB_PASS
              until nc -zv $DB_HOST 5432; do sleep 5; done

              psql -h $DB_HOST -U $DB_USER -d $DB_NAME <<SQL
              CREATE TABLE IF NOT EXISTS inventory (
                  id SERIAL PRIMARY KEY,
                  item_name VARCHAR(100),
                  category VARCHAR(50),
                  price NUMERIC(10, 2)
              );
              INSERT INTO inventory (item_name, category, price) VALUES 
              ('Lenovo Thinkpad', 'Electronics', 1200.50),
              ('Logitech MX Master 3s', 'Peripherals', 80.00)
              ON CONFLICT DO NOTHING;
SQL
              5. Create new php page which reads from database
              cat <<PHP > /var/www/html/index.php
<?php
\$host = "$DB_HOST";
\$db   = "$DB_NAME";
\$user = "$DB_USER";
\$pass = "$DB_PASS";

try {
    \$dsn = "pgsql:host=\$host;port=5432;dbname=\$db;";
    \$pdo = new PDO(\$dsn, \$user, \$pass, [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]);

    echo "<h1>Inventory from RDS</h1>";
    echo "<table border='1'><tr><th>Item</th><th>Category</th><th>Price</th></tr>";

    \$stmt = \$pdo->query("SELECT item_name, category, price FROM inventory");
    while (\$row = \$stmt->fetch()) {
        echo "<tr><td>{\$row['item_name']}</td><td>{\$row['category']}</td><td>\$" . \$row['price'] . "</td></tr>";
    }
    echo "</table>";

} catch (PDOException \$e) {
    echo "Connection failed: " . \$e->getMessage();
}
?>
PHP

              unset PGPASSWORD
              EOF
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  key_name = aws_key_pair.ssh_public_key.key_name

  tags = {
    Name        = "test-ec2"
    Description = "Test instance"
    CostCenter  = "123456"
  }
}

resource "aws_eip" "web_static_ip" {
  domain = "vpc"

  tags = {
    Name = "task1-web-eip"
  }
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.task1_web.id
  allocation_id = aws_eip.web_static_ip.id
}

resource "aws_key_pair" "ssh_public_key" {
  key_name   = "ssh-public-key"
  public_key = var.ssh_public_key
}