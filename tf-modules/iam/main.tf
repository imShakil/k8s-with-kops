# Data source for proper iam permissions required by kops
data "aws_iam_policy_document" "kops_admin_policy" {
  statement {
    sid    = "EC2FullAccess"
    effect = "Allow"
    actions = [
      "ec2:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Route53FullAccess"
    effect = "Allow"
    actions = [
      "route53:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "IAMFullAccess"
    effect = "Allow"
    actions = [
      "iam:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "SQSFullAccess"
    effect = "Allow"
    actions = [
      "sqs:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "EventBridgeFullAccess"
    effect = "Allow"
    actions = [
      "events:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "S3FullAccess"
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "VPCFullAccess"
    effect = "Allow"
    actions = [
      "ec2:*",
      "directconnect:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "ELBFullAccess"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AutoScalingFullAccess"
    effect = "Allow"
    actions = [
      "autoscaling:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_user" "kops_admin" {
  name = "${var.prefix}-admin"
  path = "/"

  tags = {
    name = ""
  }
}

resource "aws_iam_access_key" "kops_admin_key" {
  user = aws_iam_user.kops_admin.name
}

resource "aws_iam_user_policy" "kops_admin_policy" {
  name   = "${var.prefix}-admin-policy"
  user   = aws_iam_user.kops_admin.name
  policy = data.aws_iam_policy_document.kops_admin_policy.json
}
