output "name" {
  value = "${google_compute_network.default.name}"
}

output "id" {
  value = "${google_compute_network.default.self_link}"
}
