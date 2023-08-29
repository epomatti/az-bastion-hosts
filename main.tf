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

module "bastion" {
  source   = "./modules/bastion"
  sys      = var.sys
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
  subnet   = module.network.bastion_subnet_id
  sku      = var.bastion_sku
}

module "vm_linux" {
  source   = "./modules/vms/linux"
  count    = var.provision_linux_vm ? 1 : 0
  sys      = var.sys
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
  size     = var.jumpbox_size_linux
  subnet   = module.network.linux_subnet_id
}

module "vm_win" {
  source   = "./modules/vms/win"
  count    = var.provision_win_vm ? 1 : 0
  sys      = var.sys
  location = azurerm_resource_group.main.location
  group    = azurerm_resource_group.main.name
  size     = var.jumpbox_size_win
  subnet   = module.network.windows_subnet_id
}
