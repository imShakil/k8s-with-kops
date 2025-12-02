# ---------- IAM role and policy (custom policy built from data document) ----------
data "aws_iam_policy_document" "kops_admin_policy" {
  statement {
    sid     = "AllowS3"
    effect  = "Allow"
    actions = ["s3:*"]
    resources = ["*"]
  }

  statement {
    sid     = "AllowEC2"
    effect  = "Allow"
    actions = [
      "ec2:*",
      "autoscaling:*",
      "elasticloadbalancing:*"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "AllowIAM"
    effect  = "Allow"
    actions = [
      "iam:CreateRole",
      "iam:CreateInstanceProfile",
      "iam:PassRole",
      "iam:AttachRolePolicy",
      "iam:PutRolePolicy",
      "iam:GetRole",
      "iam:ListRoles"
    ]
    resources = ["*"]
  }

  statement {
    sid     = "AllowRoute53"
    effect  = "Allow"
    actions = ["route53:*"]
    resources = ["*"]
  }

  statement {
    sid     = "AllowKMSIfNeeded"
    effect  = "Allow"
    actions = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid     = "AllowCloudFormationIfNeeded"
    effect  = "Allow"
    actions = ["cloudformation:*"]
    resources = ["*"]
  }
}

resource "aws_iam_role" "kops_admin_role" {
  name = "${var.prefix}-kops-admin-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = {
    Name = "${var.prefix}-kops-admin"
  }
}

resource "aws_iam_role_policy" "kops_admin_inline" {
  name = "${var.prefix}-kops-admin-inline-policy"
  role = aws_iam_role.kops_admin_role.id
  policy = data.aws_iam_policy_document.kops_admin_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_managed_admin" {
  count      = var.attach_admin_managed_policy ? 1 : 0
  role       = aws_iam_role.kops_admin_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "kops_admin_profile" {
  name = "${var.prefix}-kops-admin-profile"
  role = aws_iam_role.kops_admin_role.name
}

# ---------- Security group ----------
resource "aws_security_group" "admin_sg" {
  name        = "${var.prefix}-kops-admin-sg"
  description = "Security group for Kops admin EC2"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.prefix}-kops-admin"
  }
}

resource "aws_security_group_rule" "allow_ssh_in" {
  for_each = toset(var.allowed_cidrs)
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [each.value]
  security_group_id = aws_security_group.admin_sg.id
  description = "Allow SSH from ${each.value}"
}

resource "aws_security_group_rule" "allow_all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.admin_sg.id
}

data "aws_ssm_parameter" "ubuntu_ami_gp2" {
  name   = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  region = var.region
}

# ---------- EC2 instance ----------
resource "aws_instance" "kops_admin" {
  ami = data.aws_ssm_parameter.ubuntu_ami_gp2.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name != "" ? var.key_name : null
  vpc_security_group_ids = [aws_security_group.admin_sg.id]
  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.kops_admin_profile.name

  user_data = file("${path.module}/setup-kops-admin.sh")

  tags = {
    Name = "${var.prefix}-kops-admin"
  }
}
