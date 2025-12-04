resource "aws_security_group" "admin_sg" {
  name        = "${var.prefix}-kops-admin-sg"
  description = "Security group for Kops admin EC2"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.prefix}-kops-admin-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_inbound" {
  security_group_id = aws_security_group.admin_sg.id
  cidr_ipv4         = var.allowed_cidrs[0]
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.admin_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

data "aws_ssm_parameter" "ubuntu_ami" {
  name   = "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id"
  region = var.region
}

resource "aws_instance" "kops_admin" {
  ami                    = data.aws_ssm_parameter.ubuntu_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.admin_sg.id]

  associate_public_ip_address = true

  tags = {
    Name = "${var.prefix}-kops-admin"
  }
}
