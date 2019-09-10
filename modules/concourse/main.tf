data "google_dns_managed_zone" "default" {
  name = "${var.dns_zone}"
}

resource "random_id" "postgres_user" {
  byte_length = 4
  prefix      = "concourse-"
}

resource "random_string" "postgres_password" {
  length  = 16
  special = true
}

resource "random_id" "concourse_admin_user" {
  byte_length = 4
  prefix      = "admin-"
}

resource "random_string" "concourse_admin_password" {
  length           = 16
  special          = true
  override_special = "!@#$%&*-_=+<>:?"
}

resource "google_compute_address" "default" {
  name = "${var.hostname}-address"
}

resource "google_dns_record_set" "default" {
  name         = "${var.hostname}.${data.google_dns_managed_zone.default.dns_name}"
  type         = "A"
  ttl          = 300
  managed_zone = "${data.google_dns_managed_zone.default.name}"
  rrdatas      = ["${google_compute_address.default.address}"]
}

locals {
  host_ip = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
}

locals {
  host_dns = "${join(".", compact(split(".", google_dns_record_set.default.name)))}"
}

locals {
  ansible_vars = {
    postgres_user            = "${random_id.postgres_user.hex}"
    postgres_password        = "${random_string.postgres_password.result}"
    concourse_host           = "${local.host_dns}"
    concourse_port           = "${var.port}"
    concourse_admin_user     = "${random_id.concourse_admin_user.hex}"
    concourse_admin_password = "${random_string.concourse_admin_password.result}"
  }
}

resource "google_compute_instance" "default" {
  name         = var.hostname
  machine_type = var.type
  tags         = var.tags

  metadata = {
    ssh-keys = "${var.admin_user.name}:${var.admin_user.ssh_public_key}"
  }

  boot_disk {
    initialize_params {
      image = var.image
    }
  }

  network_interface {
    network = var.network
    access_config {
      nat_ip = "${google_compute_address.default.address}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "echo [Update lists of packages] && sudo apt-get update --yes --quiet",
      "echo [Install Python] && sudo apt-get install --yes --quiet python",
    ]
    connection {
      type        = "ssh"
      user        = "${var.admin_user.name}"
      private_key = "${var.admin_user.ssh_private_key}"
      host        = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
    }
  }

  provisioner "local-exec" {
    command = <<-end
      ansible-playbook \
        --inventory "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}," \
        --private-key "${var.admin_user.ssh_private_key_file}" \
        --extra-vars "${join(" ", [for key, val in local.ansible_vars : "${key}=${val}"])}" \
          ./ansible/utils/ping.yaml \
          ./ansible/docker/docker-installed.yaml \
          ./ansible/docker/docker-compose-installed.yaml \
          ./ansible/concourse/concourse-installed.yaml
    end
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = false
    }
  }
}
