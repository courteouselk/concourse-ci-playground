output "host" {
  value = {
    ip  = "${local.host_ip}"
    dns = "${local.host_dns}"
  }
}

output "service" {
  value = {
    url      = "http://${local.ansible_vars.concourse_host}:${local.ansible_vars.concourse_port}/"
    user     = local.ansible_vars.concourse_admin_user
    password = local.ansible_vars.concourse_admin_password
  }
}
