data "aws_availability_zones" "azs" {
  state = "available"
}

locals {
  max_zones      = 3
  zone_count     = length(data.aws_availability_zones.azs.names)
  selected_zones = min(local.max_zones, local.zone_count)
  kops_zones     = join(",", slice(data.aws_availability_zones.azs.names, 0, local.selected_zones))
}

# ------------------------------
# IAM
# ------------------------------
module "iam" {
  source = "../tf-modules/iam"
  prefix = "${var.prefix}-${var.env}"
}

# ------------------------------
# S3 Bucket - kOps State Store
# ------------------------------
module "kops_state_store" {
  source      = "../tf-modules/s3"
  bucket_name = "${var.prefix}-state-${var.env}-${var.region}"

  tags = {
    Environment = var.env
    Project     = var.prefix
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}

# ------------------------------
# Setup kops backend configuration
# ------------------------------
resource "local_file" "kops_backend" {
  depends_on = [module.kops_state_store]
  filename   = "../kops-infra/backend.hcl"
  content = templatefile("${path.module}/templates/backend.hcl.tpl", {
    bucket_name = module.kops_state_store.bucket_name
    region      = var.region
  })
}

# ------------------------------
# Add IAM profile to aws config
# ------------------------------
resource "null_resource" "update_iam_profile" {
  depends_on = [module.iam]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "bash ../scripts/update-iam-profile.sh"
    environment = {
      AWS_ACCESS_KEY_ID     = module.iam.kops_admin_credentials.access_key_id
      AWS_SECRET_ACCESS_KEY = module.iam.kops_admin_credentials.access_key_secret
      AWS_REGION            = var.region
      KOPS_USER_NAME        = module.iam.kops_admin_user_info.user_name
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Cleanup: IAM profile update reversed'"
  }
}

# ------------------------------
# Create Cluster
# ------------------------------
resource "null_resource" "create_cluster" {
  depends_on = [module.kops_state_store, null_resource.update_iam_profile]

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "bash ../scripts/create-cluster.sh"
    environment = {
      CLUSTER_NAME     = var.cluster_name
      KOPS_STATE_STORE = "s3://${module.kops_state_store.bucket_name}"
      KOPS_ZONES       = local.kops_zones
      NODE_COUNT       = var.kops_node_count
      NODE_SIZE        = var.kops_node_size
      MASTER_SIZE      = var.kops_master_size
    }
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Cleanup: Cluster destruction handled by kops'"
  }
}
