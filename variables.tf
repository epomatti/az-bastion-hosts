### Workload ###
variable "sys" {
  type    = string
  default = "pmttinfra"
}

variable "location" {
  type    = string
  default = "eastus"
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
  type    = string
  default = "Standard_B1ls"
}

variable "jumpbox_size_win" {
  type    = string
  default = "Standard_B2s"
}
