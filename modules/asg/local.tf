locals {
  userdata_script = templatefile("${path.module}/scripts/asg_user_data.sh.tpl", {
    efs_id             = var.efs_id
    rds_endpoint       = var.rds_endpoint
    db_user            = var.db_user
    db_password        = var.db_password
    memcached_endpoint = var.memcached_endpoint
    backend_ip         = var.backend_ip
  })
}