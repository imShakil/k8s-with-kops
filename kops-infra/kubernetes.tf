locals {
  cluster_name                 = "awslab.mhosen.com"
  master_autoscaling_group_ids = [aws_autoscaling_group.control-plane-ap-southeast-1a-masters-awslab-mhosen-com.id]
  master_security_group_ids    = [aws_security_group.masters-awslab-mhosen-com.id]
  masters_role_arn             = aws_iam_role.masters-awslab-mhosen-com.arn
  masters_role_name            = aws_iam_role.masters-awslab-mhosen-com.name
  node_autoscaling_group_ids   = [aws_autoscaling_group.nodes-ap-southeast-1a-awslab-mhosen-com.id, aws_autoscaling_group.nodes-ap-southeast-1b-awslab-mhosen-com.id, aws_autoscaling_group.nodes-ap-southeast-1c-awslab-mhosen-com.id]
  node_security_group_ids      = [aws_security_group.nodes-awslab-mhosen-com.id]
  node_subnet_ids              = [aws_subnet.ap-southeast-1a-awslab-mhosen-com.id, aws_subnet.ap-southeast-1b-awslab-mhosen-com.id, aws_subnet.ap-southeast-1c-awslab-mhosen-com.id]
  nodes_role_arn               = aws_iam_role.nodes-awslab-mhosen-com.arn
  nodes_role_name              = aws_iam_role.nodes-awslab-mhosen-com.name
  region                       = "ap-southeast-1"
  route_table_public_id        = aws_route_table.awslab-mhosen-com.id
  subnet_ap-southeast-1a_id    = aws_subnet.ap-southeast-1a-awslab-mhosen-com.id
  subnet_ap-southeast-1b_id    = aws_subnet.ap-southeast-1b-awslab-mhosen-com.id
  subnet_ap-southeast-1c_id    = aws_subnet.ap-southeast-1c-awslab-mhosen-com.id
  vpc_cidr_block               = aws_vpc.awslab-mhosen-com.cidr_block
  vpc_id                       = aws_vpc.awslab-mhosen-com.id
  vpc_ipv6_cidr_block          = aws_vpc.awslab-mhosen-com.ipv6_cidr_block
  vpc_ipv6_cidr_length         = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

output "cluster_name" {
  value = "awslab.mhosen.com"
}

output "master_autoscaling_group_ids" {
  value = [aws_autoscaling_group.control-plane-ap-southeast-1a-masters-awslab-mhosen-com.id]
}

output "master_security_group_ids" {
  value = [aws_security_group.masters-awslab-mhosen-com.id]
}

output "masters_role_arn" {
  value = aws_iam_role.masters-awslab-mhosen-com.arn
}

output "masters_role_name" {
  value = aws_iam_role.masters-awslab-mhosen-com.name
}

output "node_autoscaling_group_ids" {
  value = [aws_autoscaling_group.nodes-ap-southeast-1a-awslab-mhosen-com.id, aws_autoscaling_group.nodes-ap-southeast-1b-awslab-mhosen-com.id, aws_autoscaling_group.nodes-ap-southeast-1c-awslab-mhosen-com.id]
}

output "node_security_group_ids" {
  value = [aws_security_group.nodes-awslab-mhosen-com.id]
}

output "node_subnet_ids" {
  value = [aws_subnet.ap-southeast-1a-awslab-mhosen-com.id, aws_subnet.ap-southeast-1b-awslab-mhosen-com.id, aws_subnet.ap-southeast-1c-awslab-mhosen-com.id]
}

output "nodes_role_arn" {
  value = aws_iam_role.nodes-awslab-mhosen-com.arn
}

output "nodes_role_name" {
  value = aws_iam_role.nodes-awslab-mhosen-com.name
}

output "region" {
  value = "ap-southeast-1"
}

output "route_table_public_id" {
  value = aws_route_table.awslab-mhosen-com.id
}

output "subnet_ap-southeast-1a_id" {
  value = aws_subnet.ap-southeast-1a-awslab-mhosen-com.id
}

output "subnet_ap-southeast-1b_id" {
  value = aws_subnet.ap-southeast-1b-awslab-mhosen-com.id
}

output "subnet_ap-southeast-1c_id" {
  value = aws_subnet.ap-southeast-1c-awslab-mhosen-com.id
}

output "vpc_cidr_block" {
  value = aws_vpc.awslab-mhosen-com.cidr_block
}

output "vpc_id" {
  value = aws_vpc.awslab-mhosen-com.id
}

output "vpc_ipv6_cidr_block" {
  value = aws_vpc.awslab-mhosen-com.ipv6_cidr_block
}

output "vpc_ipv6_cidr_length" {
  value = local.vpc_ipv6_cidr_block == "" ? null : tonumber(regex(".*/(\\d+)", local.vpc_ipv6_cidr_block)[0])
}

provider "aws" {
  region = "ap-southeast-1"
}

provider "aws" {
  alias  = "files"
  region = "ap-southeast-1"
}

resource "aws_autoscaling_group" "control-plane-ap-southeast-1a-masters-awslab-mhosen-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.control-plane-ap-southeast-1a-masters-awslab-mhosen-com.id
    version = aws_launch_template.control-plane-ap-southeast-1a-masters-awslab-mhosen-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "awslab.mhosen.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/control-plane"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "k8s.io/role/master"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "control-plane-ap-southeast-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/awslab.mhosen.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.ap-southeast-1a-awslab-mhosen-com.id]
}

resource "aws_autoscaling_group" "nodes-ap-southeast-1a-awslab-mhosen-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-ap-southeast-1a-awslab-mhosen-com.id
    version = aws_launch_template.nodes-ap-southeast-1a-awslab-mhosen-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "nodes-ap-southeast-1a.awslab.mhosen.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "awslab.mhosen.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1a.awslab.mhosen.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1a"
  }
  tag {
    key                 = "kubernetes.io/cluster/awslab.mhosen.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.ap-southeast-1a-awslab-mhosen-com.id]
}

resource "aws_autoscaling_group" "nodes-ap-southeast-1b-awslab-mhosen-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-ap-southeast-1b-awslab-mhosen-com.id
    version = aws_launch_template.nodes-ap-southeast-1b-awslab-mhosen-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "nodes-ap-southeast-1b.awslab.mhosen.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "awslab.mhosen.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1b.awslab.mhosen.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1b"
  }
  tag {
    key                 = "kubernetes.io/cluster/awslab.mhosen.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.ap-southeast-1b-awslab-mhosen-com.id]
}

resource "aws_autoscaling_group" "nodes-ap-southeast-1c-awslab-mhosen-com" {
  enabled_metrics = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
  launch_template {
    id      = aws_launch_template.nodes-ap-southeast-1c-awslab-mhosen-com.id
    version = aws_launch_template.nodes-ap-southeast-1c-awslab-mhosen-com.latest_version
  }
  max_instance_lifetime = 0
  max_size              = 1
  metrics_granularity   = "1Minute"
  min_size              = 1
  name                  = "nodes-ap-southeast-1c.awslab.mhosen.com"
  protect_from_scale_in = false
  tag {
    key                 = "KubernetesCluster"
    propagate_at_launch = true
    value               = "awslab.mhosen.com"
  }
  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1c.awslab.mhosen.com"
  }
  tag {
    key                 = "aws-node-termination-handler/managed"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node"
    propagate_at_launch = true
    value               = ""
  }
  tag {
    key                 = "k8s.io/role/node"
    propagate_at_launch = true
    value               = "1"
  }
  tag {
    key                 = "kops.k8s.io/instancegroup"
    propagate_at_launch = true
    value               = "nodes-ap-southeast-1c"
  }
  tag {
    key                 = "kubernetes.io/cluster/awslab.mhosen.com"
    propagate_at_launch = true
    value               = "owned"
  }
  vpc_zone_identifier = [aws_subnet.ap-southeast-1c-awslab-mhosen-com.id]
}

resource "aws_autoscaling_lifecycle_hook" "control-plane-ap-southeast-1a-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.control-plane-ap-southeast-1a-masters-awslab-mhosen-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "control-plane-ap-southeast-1a-NTHLifecycleHook"
}

resource "aws_autoscaling_lifecycle_hook" "nodes-ap-southeast-1a-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.nodes-ap-southeast-1a-awslab-mhosen-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "nodes-ap-southeast-1a-NTHLifecycleHook"
}

resource "aws_autoscaling_lifecycle_hook" "nodes-ap-southeast-1b-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.nodes-ap-southeast-1b-awslab-mhosen-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "nodes-ap-southeast-1b-NTHLifecycleHook"
}

resource "aws_autoscaling_lifecycle_hook" "nodes-ap-southeast-1c-NTHLifecycleHook" {
  autoscaling_group_name = aws_autoscaling_group.nodes-ap-southeast-1c-awslab-mhosen-com.id
  default_result         = "CONTINUE"
  heartbeat_timeout      = 300
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
  name                   = "nodes-ap-southeast-1c-NTHLifecycleHook"
}

resource "aws_cloudwatch_event_rule" "awslab-mhosen-com-ASGLifecycle" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_awslab.mhosen.com-ASGLifecycle_event_pattern")
  name          = "awslab.mhosen.com-ASGLifecycle"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com-ASGLifecycle"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "awslab-mhosen-com-InstanceScheduledChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_awslab.mhosen.com-InstanceScheduledChange_event_pattern")
  name          = "awslab.mhosen.com-InstanceScheduledChange"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com-InstanceScheduledChange"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "awslab-mhosen-com-InstanceStateChange" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_awslab.mhosen.com-InstanceStateChange_event_pattern")
  name          = "awslab.mhosen.com-InstanceStateChange"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com-InstanceStateChange"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_cloudwatch_event_rule" "awslab-mhosen-com-SpotInterruption" {
  event_pattern = file("${path.module}/data/aws_cloudwatch_event_rule_awslab.mhosen.com-SpotInterruption_event_pattern")
  name          = "awslab.mhosen.com-SpotInterruption"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com-SpotInterruption"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_cloudwatch_event_target" "awslab-mhosen-com-ASGLifecycle-Target" {
  arn  = aws_sqs_queue.awslab-mhosen-com-nth.arn
  rule = aws_cloudwatch_event_rule.awslab-mhosen-com-ASGLifecycle.id
}

resource "aws_cloudwatch_event_target" "awslab-mhosen-com-InstanceScheduledChange-Target" {
  arn  = aws_sqs_queue.awslab-mhosen-com-nth.arn
  rule = aws_cloudwatch_event_rule.awslab-mhosen-com-InstanceScheduledChange.id
}

resource "aws_cloudwatch_event_target" "awslab-mhosen-com-InstanceStateChange-Target" {
  arn  = aws_sqs_queue.awslab-mhosen-com-nth.arn
  rule = aws_cloudwatch_event_rule.awslab-mhosen-com-InstanceStateChange.id
}

resource "aws_cloudwatch_event_target" "awslab-mhosen-com-SpotInterruption-Target" {
  arn  = aws_sqs_queue.awslab-mhosen-com-nth.arn
  rule = aws_cloudwatch_event_rule.awslab-mhosen-com-SpotInterruption.id
}

resource "aws_ebs_volume" "a-etcd-events-awslab-mhosen-com" {
  availability_zone = "ap-southeast-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "a.etcd-events.awslab.mhosen.com"
    "k8s.io/etcd/events"                      = "a/a"
    "k8s.io/role/control-plane"               = "1"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_ebs_volume" "a-etcd-main-awslab-mhosen-com" {
  availability_zone = "ap-southeast-1a"
  encrypted         = true
  iops              = 3000
  size              = 20
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "a.etcd-main.awslab.mhosen.com"
    "k8s.io/etcd/main"                        = "a/a"
    "k8s.io/role/control-plane"               = "1"
    "k8s.io/role/master"                      = "1"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
  throughput = 125
  type       = "gp3"
}

resource "aws_iam_instance_profile" "masters-awslab-mhosen-com" {
  name = "masters.awslab.mhosen.com"
  role = aws_iam_role.masters-awslab-mhosen-com.name
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "masters.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_iam_instance_profile" "nodes-awslab-mhosen-com" {
  name = "nodes.awslab.mhosen.com"
  role = aws_iam_role.nodes-awslab-mhosen-com.name
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "nodes.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_iam_role" "masters-awslab-mhosen-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_masters.awslab.mhosen.com_policy")
  name               = "masters.awslab.mhosen.com"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "masters.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_iam_role" "nodes-awslab-mhosen-com" {
  assume_role_policy = file("${path.module}/data/aws_iam_role_nodes.awslab.mhosen.com_policy")
  name               = "nodes.awslab.mhosen.com"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "nodes.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_iam_role_policy" "masters-awslab-mhosen-com" {
  name   = "masters.awslab.mhosen.com"
  policy = file("${path.module}/data/aws_iam_role_policy_masters.awslab.mhosen.com_policy")
  role   = aws_iam_role.masters-awslab-mhosen-com.name
}

resource "aws_iam_role_policy" "nodes-awslab-mhosen-com" {
  name   = "nodes.awslab.mhosen.com"
  policy = file("${path.module}/data/aws_iam_role_policy_nodes.awslab.mhosen.com_policy")
  role   = aws_iam_role.nodes-awslab-mhosen-com.name
}

resource "aws_internet_gateway" "awslab-mhosen-com" {
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_key_pair" "kubernetes-awslab-mhosen-com-7ad42201186d3bfa5eb3b218c6def8a4" {
  key_name   = "kubernetes.awslab.mhosen.com-7a:d4:22:01:18:6d:3b:fa:5e:b3:b2:18:c6:de:f8:a4"
  public_key = file("${path.module}/data/aws_key_pair_kubernetes.awslab.mhosen.com-7ad42201186d3bfa5eb3b218c6def8a4_public_key")
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_launch_template" "control-plane-ap-southeast-1a-masters-awslab-mhosen-com" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 64
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.masters-awslab-mhosen-com.id
  }
  image_id      = "ami-02c7683e4ca3ebf58"
  instance_type = "t2.medium"
  key_name      = aws_key_pair.kubernetes-awslab-mhosen-com-7ad42201186d3bfa5eb3b218c6def8a4.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.masters-awslab-mhosen-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                                                     = "awslab.mhosen.com"
      "Name"                                                                                                  = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "control-plane-ap-southeast-1a"
      "kubernetes.io/cluster/awslab.mhosen.com"                                                               = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                                                     = "awslab.mhosen.com"
      "Name"                                                                                                  = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                                                  = ""
      "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
      "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
      "k8s.io/role/control-plane"                                                                             = "1"
      "k8s.io/role/master"                                                                                    = "1"
      "kops.k8s.io/instancegroup"                                                                             = "control-plane-ap-southeast-1a"
      "kubernetes.io/cluster/awslab.mhosen.com"                                                               = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                                                     = "awslab.mhosen.com"
    "Name"                                                                                                  = "control-plane-ap-southeast-1a.masters.awslab.mhosen.com"
    "aws-node-termination-handler/managed"                                                                  = ""
    "k8s.io/cluster-autoscaler/node-template/label/kops.k8s.io/kops-controller-pki"                         = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/control-plane"                   = ""
    "k8s.io/cluster-autoscaler/node-template/label/node.kubernetes.io/exclude-from-external-load-balancers" = ""
    "k8s.io/role/control-plane"                                                                             = "1"
    "k8s.io/role/master"                                                                                    = "1"
    "kops.k8s.io/instancegroup"                                                                             = "control-plane-ap-southeast-1a"
    "kubernetes.io/cluster/awslab.mhosen.com"                                                               = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_control-plane-ap-southeast-1a.masters.awslab.mhosen.com_user_data")
}

resource "aws_launch_template" "nodes-ap-southeast-1a-awslab-mhosen-com" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 128
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-awslab-mhosen-com.id
  }
  image_id      = "ami-02c7683e4ca3ebf58"
  instance_type = "t2.small"
  key_name      = aws_key_pair.kubernetes-awslab-mhosen-com-7ad42201186d3bfa5eb3b218c6def8a4.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "nodes-ap-southeast-1a.awslab.mhosen.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-awslab-mhosen-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1a.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1a"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1a.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1a"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "awslab.mhosen.com"
    "Name"                                                                       = "nodes-ap-southeast-1a.awslab.mhosen.com"
    "aws-node-termination-handler/managed"                                       = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1a"
    "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes-ap-southeast-1a.awslab.mhosen.com_user_data")
}

resource "aws_launch_template" "nodes-ap-southeast-1b-awslab-mhosen-com" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 128
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-awslab-mhosen-com.id
  }
  image_id      = "ami-02c7683e4ca3ebf58"
  instance_type = "t2.small"
  key_name      = aws_key_pair.kubernetes-awslab-mhosen-com-7ad42201186d3bfa5eb3b218c6def8a4.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "nodes-ap-southeast-1b.awslab.mhosen.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-awslab-mhosen-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1b.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1b"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1b.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1b"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "awslab.mhosen.com"
    "Name"                                                                       = "nodes-ap-southeast-1b.awslab.mhosen.com"
    "aws-node-termination-handler/managed"                                       = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1b"
    "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes-ap-southeast-1b.awslab.mhosen.com_user_data")
}

resource "aws_launch_template" "nodes-ap-southeast-1c-awslab-mhosen-com" {
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      encrypted             = true
      iops                  = 3000
      throughput            = 125
      volume_size           = 128
      volume_type           = "gp3"
    }
  }
  iam_instance_profile {
    name = aws_iam_instance_profile.nodes-awslab-mhosen-com.id
  }
  image_id      = "ami-02c7683e4ca3ebf58"
  instance_type = "t2.small"
  key_name      = aws_key_pair.kubernetes-awslab-mhosen-com-7ad42201186d3bfa5eb3b218c6def8a4.id
  lifecycle {
    create_before_destroy = true
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "required"
  }
  monitoring {
    enabled = false
  }
  name = "nodes-ap-southeast-1c.awslab.mhosen.com"
  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    ipv6_address_count          = 0
    security_groups             = [aws_security_group.nodes-awslab-mhosen-com.id]
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1c.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1c"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      "KubernetesCluster"                                                          = "awslab.mhosen.com"
      "Name"                                                                       = "nodes-ap-southeast-1c.awslab.mhosen.com"
      "aws-node-termination-handler/managed"                                       = ""
      "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
      "k8s.io/role/node"                                                           = "1"
      "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1c"
      "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
    }
  }
  tags = {
    "KubernetesCluster"                                                          = "awslab.mhosen.com"
    "Name"                                                                       = "nodes-ap-southeast-1c.awslab.mhosen.com"
    "aws-node-termination-handler/managed"                                       = ""
    "k8s.io/cluster-autoscaler/node-template/label/node-role.kubernetes.io/node" = ""
    "k8s.io/role/node"                                                           = "1"
    "kops.k8s.io/instancegroup"                                                  = "nodes-ap-southeast-1c"
    "kubernetes.io/cluster/awslab.mhosen.com"                                    = "owned"
  }
  user_data = filebase64("${path.module}/data/aws_launch_template_nodes-ap-southeast-1c.awslab.mhosen.com_user_data")
}

resource "aws_route" "route-0-0-0-0--0" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.awslab-mhosen-com.id
  route_table_id         = aws_route_table.awslab-mhosen-com.id
}

resource "aws_route" "route-__--0" {
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.awslab-mhosen-com.id
  route_table_id              = aws_route_table.awslab-mhosen-com.id
}

resource "aws_route_table" "awslab-mhosen-com" {
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
    "kubernetes.io/kops/role"                 = "public"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_route_table_association" "ap-southeast-1a-awslab-mhosen-com" {
  route_table_id = aws_route_table.awslab-mhosen-com.id
  subnet_id      = aws_subnet.ap-southeast-1a-awslab-mhosen-com.id
}

resource "aws_route_table_association" "ap-southeast-1b-awslab-mhosen-com" {
  route_table_id = aws_route_table.awslab-mhosen-com.id
  subnet_id      = aws_subnet.ap-southeast-1b-awslab-mhosen-com.id
}

resource "aws_route_table_association" "ap-southeast-1c-awslab-mhosen-com" {
  route_table_id = aws_route_table.awslab-mhosen-com.id
  subnet_id      = aws_subnet.ap-southeast-1c-awslab-mhosen-com.id
}

resource "aws_s3_object" "awslab-mhosen-com-addons-aws-cloud-controller-addons-k8s-io-k8s-1-18" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-aws-cloud-controller.addons.k8s.io-k8s-1.18_content")
  key      = "awslab.mhosen.com/addons/aws-cloud-controller.addons.k8s.io/k8s-1.18.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-aws-ebs-csi-driver-addons-k8s-io-k8s-1-17" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-aws-ebs-csi-driver.addons.k8s.io-k8s-1.17_content")
  key      = "awslab.mhosen.com/addons/aws-ebs-csi-driver.addons.k8s.io/k8s-1.17.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-bootstrap" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-bootstrap_content")
  key      = "awslab.mhosen.com/addons/bootstrap-channel.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-coredns-addons-k8s-io-k8s-1-12" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-coredns.addons.k8s.io-k8s-1.12_content")
  key      = "awslab.mhosen.com/addons/coredns.addons.k8s.io/k8s-1.12.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-dns-controller-addons-k8s-io-k8s-1-12" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-dns-controller.addons.k8s.io-k8s-1.12_content")
  key      = "awslab.mhosen.com/addons/dns-controller.addons.k8s.io/k8s-1.12.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-kops-controller-addons-k8s-io-k8s-1-16" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-kops-controller.addons.k8s.io-k8s-1.16_content")
  key      = "awslab.mhosen.com/addons/kops-controller.addons.k8s.io/k8s-1.16.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-kubelet-api-rbac-addons-k8s-io-k8s-1-9" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-kubelet-api.rbac.addons.k8s.io-k8s-1.9_content")
  key      = "awslab.mhosen.com/addons/kubelet-api.rbac.addons.k8s.io/k8s-1.9.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-limit-range-addons-k8s-io" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-limit-range.addons.k8s.io_content")
  key      = "awslab.mhosen.com/addons/limit-range.addons.k8s.io/v1.5.0.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-networking-projectcalico-org-k8s-1-25" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-networking.projectcalico.org-k8s-1.25_content")
  key      = "awslab.mhosen.com/addons/networking.projectcalico.org/k8s-1.25.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-node-termination-handler-aws-k8s-1-11" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-node-termination-handler.aws-k8s-1.11_content")
  key      = "awslab.mhosen.com/addons/node-termination-handler.aws/k8s-1.11.yaml"
  provider = aws.files
}

resource "aws_s3_object" "awslab-mhosen-com-addons-storage-aws-addons-k8s-io-v1-15-0" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_awslab.mhosen.com-addons-storage-aws.addons.k8s.io-v1.15.0_content")
  key      = "awslab.mhosen.com/addons/storage-aws.addons.k8s.io/v1.15.0.yaml"
  provider = aws.files
}

resource "aws_s3_object" "cluster-completed-spec" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_cluster-completed.spec_content")
  key      = "awslab.mhosen.com/cluster-completed.spec"
  provider = aws.files
}

resource "aws_s3_object" "etcd-cluster-spec-events" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-events_content")
  key      = "awslab.mhosen.com/backups/etcd/events/control/etcd-cluster-spec"
  provider = aws.files
}

resource "aws_s3_object" "etcd-cluster-spec-main" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_etcd-cluster-spec-main_content")
  key      = "awslab.mhosen.com/backups/etcd/main/control/etcd-cluster-spec"
  provider = aws.files
}

resource "aws_s3_object" "kops-version-txt" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_kops-version.txt_content")
  key      = "awslab.mhosen.com/kops-version.txt"
  provider = aws.files
}

resource "aws_s3_object" "manifests-etcdmanager-events-control-plane-ap-southeast-1a" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-events-control-plane-ap-southeast-1a_content")
  key      = "awslab.mhosen.com/manifests/etcd/events-control-plane-ap-southeast-1a.yaml"
  provider = aws.files
}

resource "aws_s3_object" "manifests-etcdmanager-main-control-plane-ap-southeast-1a" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_manifests-etcdmanager-main-control-plane-ap-southeast-1a_content")
  key      = "awslab.mhosen.com/manifests/etcd/main-control-plane-ap-southeast-1a.yaml"
  provider = aws.files
}

resource "aws_s3_object" "manifests-static-kube-apiserver-healthcheck" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_manifests-static-kube-apiserver-healthcheck_content")
  key      = "awslab.mhosen.com/manifests/static/kube-apiserver-healthcheck.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-control-plane-ap-southeast-1a" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-control-plane-ap-southeast-1a_content")
  key      = "awslab.mhosen.com/igconfig/control-plane/control-plane-ap-southeast-1a/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-nodes-ap-southeast-1a" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-nodes-ap-southeast-1a_content")
  key      = "awslab.mhosen.com/igconfig/node/nodes-ap-southeast-1a/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-nodes-ap-southeast-1b" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-nodes-ap-southeast-1b_content")
  key      = "awslab.mhosen.com/igconfig/node/nodes-ap-southeast-1b/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_s3_object" "nodeupconfig-nodes-ap-southeast-1c" {
  bucket   = "kops-kops-state-dev-ap-southeast-1"
  content  = file("${path.module}/data/aws_s3_object_nodeupconfig-nodes-ap-southeast-1c_content")
  key      = "awslab.mhosen.com/igconfig/node/nodes-ap-southeast-1c/nodeupconfig.yaml"
  provider = aws.files
}

resource "aws_security_group" "masters-awslab-mhosen-com" {
  description = "Security group for masters"
  name        = "masters.awslab.mhosen.com"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "masters.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_security_group" "nodes-awslab-mhosen-com" {
  description = "Security group for nodes"
  name        = "nodes.awslab.mhosen.com"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "nodes.awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-masters-awslab-mhosen-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-22to22-nodes-awslab-mhosen-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-0-0-0-0--0-ingress-tcp-443to443-masters-awslab-mhosen-com" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-masters-awslab-mhosen-com" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-22to22-nodes-awslab-mhosen-com" {
  from_port         = 22
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port           = 22
  type              = "ingress"
}

resource "aws_security_group_rule" "from-__--0-ingress-tcp-443to443-masters-awslab-mhosen-com" {
  from_port         = 443
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "tcp"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "from-masters-awslab-mhosen-com-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-awslab-mhosen-com-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-masters-awslab-mhosen-com-ingress-all-0to0-masters-awslab-mhosen-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-masters-awslab-mhosen-com-ingress-all-0to0-nodes-awslab-mhosen-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.masters-awslab-mhosen-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-egress-all-0to0-0-0-0-0--0" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-egress-all-0to0-__--0" {
  from_port         = 0
  ipv6_cidr_blocks  = ["::/0"]
  protocol          = "-1"
  security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-4-0to0-masters-awslab-mhosen-com" {
  from_port                = 0
  protocol                 = "4"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-all-0to0-nodes-awslab-mhosen-com" {
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.nodes-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 0
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-tcp-1to2379-masters-awslab-mhosen-com" {
  from_port                = 1
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 2379
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-tcp-2382to4000-masters-awslab-mhosen-com" {
  from_port                = 2382
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 4000
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-tcp-4003to65535-masters-awslab-mhosen-com" {
  from_port                = 4003
  protocol                 = "tcp"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "from-nodes-awslab-mhosen-com-ingress-udp-1to65535-masters-awslab-mhosen-com" {
  from_port                = 1
  protocol                 = "udp"
  security_group_id        = aws_security_group.masters-awslab-mhosen-com.id
  source_security_group_id = aws_security_group.nodes-awslab-mhosen-com.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_sqs_queue" "awslab-mhosen-com-nth" {
  message_retention_seconds = 300
  name                      = "awslab-mhosen-com-nth"
  policy                    = file("${path.module}/data/aws_sqs_queue_awslab-mhosen-com-nth_policy")
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab-mhosen-com-nth"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_subnet" "ap-southeast-1a-awslab-mhosen-com" {
  availability_zone                           = "ap-southeast-1a"
  cidr_block                                  = "172.20.0.0/18"
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch         = "resource-name"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "ap-southeast-1a.awslab.mhosen.com"
    "SubnetType"                              = "Public"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
    "kubernetes.io/role/elb"                  = "1"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_subnet" "ap-southeast-1b-awslab-mhosen-com" {
  availability_zone                           = "ap-southeast-1b"
  cidr_block                                  = "172.20.64.0/18"
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch         = "resource-name"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "ap-southeast-1b.awslab.mhosen.com"
    "SubnetType"                              = "Public"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
    "kubernetes.io/role/elb"                  = "1"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_subnet" "ap-southeast-1c-awslab-mhosen-com" {
  availability_zone                           = "ap-southeast-1c"
  cidr_block                                  = "172.20.128.0/18"
  enable_resource_name_dns_a_record_on_launch = true
  private_dns_hostname_type_on_launch         = "resource-name"
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "ap-southeast-1c.awslab.mhosen.com"
    "SubnetType"                              = "Public"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
    "kubernetes.io/role/elb"                  = "1"
    "kubernetes.io/role/internal-elb"         = "1"
  }
  vpc_id = aws_vpc.awslab-mhosen-com.id
}

resource "aws_vpc" "awslab-mhosen-com" {
  assign_generated_ipv6_cidr_block = true
  cidr_block                       = "172.20.0.0/16"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options" "awslab-mhosen-com" {
  domain_name         = "ap-southeast-1.compute.internal"
  domain_name_servers = ["AmazonProvidedDNS"]
  tags = {
    "KubernetesCluster"                       = "awslab.mhosen.com"
    "Name"                                    = "awslab.mhosen.com"
    "kubernetes.io/cluster/awslab.mhosen.com" = "owned"
  }
}

resource "aws_vpc_dhcp_options_association" "awslab-mhosen-com" {
  dhcp_options_id = aws_vpc_dhcp_options.awslab-mhosen-com.id
  vpc_id          = aws_vpc.awslab-mhosen-com.id
}

terraform {
  required_version = ">= 0.15.0"
  required_providers {
    aws = {
      "configuration_aliases" = [aws.files]
      "source"                = "hashicorp/aws"
      "version"               = ">= 5.0.0"
    }
  }
}
