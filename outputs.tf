output "rds_endpoint" {
  value = aws_db_instance.mysql_rds.endpoint
}

output "rds_username" {
  value = aws_db_instance.mysql_rds.username
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
}
