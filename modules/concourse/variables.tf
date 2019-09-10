variable "hostname" {
  type = string
}

variable "port" {
  type = number
}

variable "dns_zone" {
  type = string
}

variable "type" {
  type    = string
  default = "g1-small"
}

variable "image" {
  type    = string
  default = "ubuntu-os-cloud/ubuntu-1804-lts" # https://cloud.google.com/compute/docs/images
}

variable "network" {
  type = string
}

variable "tags" {
  type = list
}

variable "admin_user" {
  type = object({
    name                 = string,
    ssh_private_key_file = string,
    ssh_private_key      = string,
    ssh_public_key_file  = string,
    ssh_public_key       = string,
  })
}
