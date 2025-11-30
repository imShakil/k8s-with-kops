resource "aws_ecr_repository" "frontend" {
  name = "${var.org_prefix}-${var.env}-frontend"
}

resource "aws_ecr_repository" "backend" {
  name = "${var.org_prefix}-${var.env}-backend"
}

resource "aws_ecr_repository" "database" {
  name = "${var.org_prefix}-${var.env}-database"
}

