resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repositories)
  name     = "${var.org_prefix}-${var.env}-${each.value}"
}

resource "aws_ecr_lifecycle_policy" "repos" {
  for_each      = aws_ecr_repository.repos
  repository    = each.value.name
  policy        = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 30 days"
        selection    = {
          tagStatus = "untagged"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
