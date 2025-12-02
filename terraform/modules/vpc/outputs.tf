output "vpc_info" {
  description = "All relevant VPC info for other modules"
  value = {
    vpc_id             = aws_vpc.kops_vpc.id
    vpc_cidr           = aws_vpc.kops_vpc.cidr_block
    kops_sg_id         = aws_security_group.kops_sg.id
    rds_sg_id          = aws_security_group.rds_sg.id
    public_subnet_ids  = aws_subnet.public_subnets[*].id
    private_subnet_ids = aws_subnet.private_subnets[*].id
    availability_zones = data.aws_availability_zones.azs.names
  }
}