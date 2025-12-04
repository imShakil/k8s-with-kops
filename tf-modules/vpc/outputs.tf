output "vpc_info" {
  value = {
    vpc_id              = aws_vpc.kops_vpc.id
    vpc_cidr            = aws_vpc.kops_vpc.cidr_block
    security_group_id   = aws_security_group.kops_sg.id
    public_subnet_ids   = aws_subnet.public_subnets[*].id
    private_subnet_ids  = aws_subnet.private_subnets[*].id
    public_subnets_azs  = aws_subnet.public_subnets[*].availability_zone
    private_subnets_azs = aws_subnet.private_subnets[*].availability_zone
    public_subnet_tags  = aws_subnet.public_subnets[*].tags
    private_subnet_tags = aws_subnet.private_subnets[*].tags
  }
}
