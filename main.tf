terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "rg-${var.sys}"
  location = var.location
}

module "network" {
  source   = "./modules/network"
  sys      = var.sys
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
}

module "vm_linux" {
  source         = "./modules/vms/linux"
  count          = var.provision_linux_vm ? 1 : 0
  sys            = var.sys
  location       = azurerm_resource_group.main.location
  group          = azurerm_resource_group.main.name
  jumpbox_size   = var.jumpbox_size_linux
  jumpbox_subnet = module.network.jumpbox_subnet_id
}

module "vm_win" {
  source         = "./modules/vms/win"
  count          = var.provision_win_vm ? 1 : 0
  sys            = var.sys
  location       = azurerm_resource_group.main.location
  group          = azurerm_resource_group.main.name
  jumpbox_size   = var.jumpbox_size_win
  jumpbox_subnet = module.network.jumpbox_subnet_id
}
