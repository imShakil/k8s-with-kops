# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.prefix}-rds-sg"
  description = "Allow RDS access from Kubernetes nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-rds-sg"
  }
}

# Ingress rule to allow Kops nodes
resource "aws_security_group_rule" "allow_k8s_nodes" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = var.kops_sg_id
}

# DB Subnet Group
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.prefix}-${var.env}-${var.region}"
  subnet_ids = var.db_subnet_ids
}

# RDS Instance
resource "aws_db_instance" "mysql_rds" {
  identifier             = "mysql-${terraform.workspace}"
  allocated_storage      = 10
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.db_user
  password               = var.db_pass
  skip_final_snapshot    = true
  multi_az               = false
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

# Store password in Secrets Manager
resource "aws_secretsmanager_secret" "rds_secret" {
  name = "my-rds-password-${terraform.workspace}"
}

resource "aws_secretsmanager_secret_version" "rds_secret_value" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    username = var.db_user
    password = var.db_pass
    dbname   = var.db_name
  })
}
