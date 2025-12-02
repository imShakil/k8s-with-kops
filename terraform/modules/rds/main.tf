

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.prefix}-${var.env}-${var.region}"
  subnet_ids = var.db_subnet_ids
#   tags = {
#     Name = "${var.prefix}-${}"
# }
}

resource "aws_db_instance" "mysql_rds" {
  identifier = "mysql-${terraform.workspace}"
  allocated_storage    = 10
  db_name              = var.db_name
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = var.db_user
  password             = var.db_pass
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.priv_sg_id]
  multi_az = false
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
#   tags = {
#     Name = "${var.prefix}-${}"
#   }
}


# Store the password in Secrets Manager
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "my-rds-password-${terraform.workspace}"
#   tags = {
#     Name = "${var.prefix}-${}"
#   }
}

# Put the generated password into the secret
resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.db_user
    password = var.db_pass
    dbname   = var.db_name
  })
}