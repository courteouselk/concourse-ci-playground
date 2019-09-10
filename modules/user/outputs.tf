output "name" {
  value = var.name
}

output "ssh_public_key_file" {
  value = var.ssh_public_key_file
}

output "ssh_public_key" {
  value = "${file(var.ssh_public_key_file)}"
}

output "ssh_private_key_file" {
  value = var.ssh_private_key_file
}

output "ssh_private_key" {
  value = "${file(var.ssh_private_key_file)}"
}
