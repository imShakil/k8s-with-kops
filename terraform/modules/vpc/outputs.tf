output "vpc_info" {
  value = {
    vpc_id = aws_vpc.kops_vpc.id
    vpc_cidr = aws_vpc.kops_vpc.cidr_block
    security_group_id = aws_security_group.kops_sg.id
    public_subnet_ids = aws_subnet.public_subnets[*].id
    private_subnet_ids = aws_subnet.private_subnets[*].id
    availability_zones = data.aws_availability_zones.azs.names
    public_subnet_tags = aws_subnet.public_subnets[*].tags
    private_subnet_tags = aws_subnet.private_subnets[*].tags
  }
}
