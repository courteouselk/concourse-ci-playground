resource "random_integer" "concourse_port" {
  min = 5000
  max = 5999
}

locals {
  concourse_port = "${random_integer.concourse_port.result}"
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "allow-icmp"
  network = var.network

  allow {
    protocol = "icmp"
  }

  target_tags = [var.tag_allow_icmp]
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_tags = [var.tag_allow_ssh]
}

resource "google_compute_firewall" "allow_concourse" {
  name    = "allow-concourse"
  network = var.network

  allow {
    protocol = "tcp"
    ports    = ["${local.concourse_port}"]
  }

  target_tags = [var.tag_allow_concourse]
}
