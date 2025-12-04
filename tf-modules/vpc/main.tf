data "aws_availability_zones" "azs" {
  state = "available"
}
locals {
  public_subnets = length(var.public_subnets) > 0 ? var.public_subnets : [
    for i in range(var.subnet_size) : cidrsubnet(var.vpc_cidr, 8, i)
  ]

  private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : [
    for i in range(var.subnet_size) : cidrsubnet(var.vpc_cidr, 8, i + 128)
  ]
}

resource "aws_vpc" "kops_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.prefix}-vpc"
  }
}
resource "aws_internet_gateway" "kops_igw" {
  vpc_id = aws_vpc.kops_vpc.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}
resource "aws_route_table" "kops_public_rt" {
  vpc_id = aws_vpc.kops_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.kops_igw.id
  }
  tags = {
    Name = "${var.prefix}-public-rt"
  }
}

resource "aws_route_table" "kops_private_rt" {
  vpc_id = aws_vpc.kops_vpc.id
  tags = {
    Name = "${var.prefix}-private-rt"
  }
}

resource "aws_security_group" "kops_sg" {
  vpc_id      = aws_vpc.kops_vpc.id
  name        = "${var.prefix}-sg"
  description = "Security Group for ${var.prefix}-vpc"
  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.kops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.kops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}
resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.kops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allows_vpc_internal" {
  security_group_id = aws_security_group.kops_sg.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allows_egress_all" {
  security_group_id = aws_security_group.kops_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allows all egress traffic"
}

resource "aws_subnet" "public_subnets" {
  count                   = var.subnet_size
  vpc_id                  = aws_vpc.kops_vpc.id
  cidr_block              = local.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  tags = {
    Name = "${var.prefix}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = var.subnet_size
  vpc_id            = aws_vpc.kops_vpc.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.azs.names[count.index % length(data.aws_availability_zones.azs.names)]
  tags = {
    Name = "${var.prefix}-private-subnet-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = var.subnet_size
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.kops_public_rt.id
}

resource "aws_route_table_association" "private_rt_association" {
  count          = var.subnet_size
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.kops_private_rt.id
}
