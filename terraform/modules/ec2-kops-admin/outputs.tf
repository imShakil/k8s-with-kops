output "public_ip" {
  value = aws_instance.kops_admin.public_ip
}

output "instance_id" {
  value = aws_instance.kops_admin.id
}

output "security_group_id" {
  value = aws_security_group.admin_sg.id
}
