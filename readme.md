# Concourse CI playground

Deploy a sandbox Concourse CI host on GCP.

- Create GCP project
- Create DNS zone and sort out nameservers
- `terraform init`
- `terraform plan`
- `terraform apply`

## Necessary files

```txt
.keys/
  + terraform-credentials.json  :  GCE account key for Terraform
.ssh/
  + id_rsa                      :  Private SSH key for root user
  + id_rsa.pub                  :  Public SSH kye for root user
```
