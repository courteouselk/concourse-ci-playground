output "tag" {
  value = {
    allow_icmp      = var.tag_allow_icmp
    allow_ssh       = var.tag_allow_ssh
    allow_concourse = var.tag_allow_concourse
  }
}

output "port" {
  value = {
    concourse = local.concourse_port
  }
}
