output "web_public_ip" {
  value       = aws_eip.web_static_ip.public_ip
  description = "Public IP address of the web server"
}

output "rds_endpoint" {
  value       = aws_db_instance.task1_db.endpoint
  description = "The connection endpoint for the RDS database"
}