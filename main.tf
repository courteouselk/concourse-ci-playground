provider "google" {
  version     = "~> 2.12"
  credentials = "${file(".keys/terraform-credentials.json")}"
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}

provider "random" {
  version = "~> 2.2"
}

module "network" {
  source = "./modules/network"
  name   = var.gcp_network
}

module "firewall_rules" {
  source  = "./modules/firewall_rules"
  network = module.network.id
}

module "concourse_root_user" {
  source               = "./modules/user"
  name                 = var.concourse_root_user
  ssh_public_key_file  = ".ssh/id_rsa.pub"
  ssh_private_key_file = ".ssh/id_rsa"
}

module "concourse" {
  source     = "./modules/concourse"
  hostname   = var.concourse_hostname
  dns_zone   = var.gcp_dns_zone
  network    = module.network.name
  port       = module.firewall_rules.port.concourse
  admin_user = module.concourse_root_user

  tags = [
    module.firewall_rules.tag.allow_icmp,
    module.firewall_rules.tag.allow_ssh,
    module.firewall_rules.tag.allow_concourse,
  ]
}
