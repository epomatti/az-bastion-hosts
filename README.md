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



```
terraform init
terraform apply -auto-approve
```


