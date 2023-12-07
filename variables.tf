### Workload ###
variable "sys" {
  type    = string
  default = "bastionhosts"
}

variable "location" {
  type = string
}

### Bastion ###
variable "bastion_sku" {
  type = string
}

### Jumpbox ###
variable "provision_linux_vm" {
  type    = bool
  default = true
}

variable "provision_win_vm" {
  type    = bool
  default = true
}

variable "jumpbox_size_linux" {
  type = string
}

variable "jumpbox_size_win" {
  type = string
}

variable "entraid_tenant_domain" {
  type = string
}

variable "vmadmin_user_name" {
  type = string
}

variable "vmadmin_user_password" {
  type      = string
  sensitive = true
}
