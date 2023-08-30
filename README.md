# Azure Bastion Hosts

Bastion configuration with Windows and Linux VMs.

Create the `.auto.tfvars` file and set up your variables:

```terraform
# Location
location = "eastus"

# Bastion
bastion_sku = "Basic"

# VMs
provision_linux_vm = true
provision_win_vm   = true
```

Before applying, create a temporary key pair for SSH to the Linux machine:

```sh
ssh-keygen -f ./modules/vms/linux/id_rsa
```

Create the resources:

```sh
terraform init
terraform apply -auto-approve
```
