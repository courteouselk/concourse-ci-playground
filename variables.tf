variable "gcp_project" {
  type        = string
  description = "Pre-existing GCP project to deploy Concourse CI at"
}

variable "gcp_dns_zone" {
  type        = string
  description = "Pre-existing DNS zone for Concourse CI"
}

variable "gcp_region" {
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "gcp_network" {
  type    = string
  default = "concourse-network"
}

variable "concourse_hostname" {
  type    = string
  default = "concourse-ci"
}

variable "concourse_root_user" {
  type = string
}
