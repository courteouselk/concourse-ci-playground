variable "network" {
  type = string
}

variable "tag_allow_icmp" {
  type    = string
  default = "allow-icmp"
}

variable "tag_allow_ssh" {
  type    = string
  default = "allow-ssh"
}

variable "tag_allow_concourse" {
  type    = string
  default = "allow-concourse"
}
