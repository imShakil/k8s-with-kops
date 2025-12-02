output "rds_secret_arn" {
    value = aws_secretsmanager_secret.rds_secret.arn
}

output "rds_endpoint" {
    value = aws_db_instance.mysql_rds.endpoint 
}

output "dbhost" {
    value = aws_db_instance.mysql_rds.address
  
}