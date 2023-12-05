# Azure Bastion Hosts

Bastion configuration with Windows and Linux VMs. Adapted from the official [docs][1]:

<img src=".assets/bastion.png" />

Create the `.auto.tfvars` from the template and set the variables:

```sh
cp config/template.tfvars .auto.tfvars
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

Connectivity will be available with SSH and RDP for the Linux and Windows machines respectively.

To try out native SDK features, upgrade Bastion to the `Standard` SKU:

```terraform
bastion_sku = "Standard"
```

---

### Clean-up

Destroy the resources after using it:

```sh
terraform destroy -auto-approve
```


[1]: https://learn.microsoft.com/en-us/azure/bastion/bastion-overview
