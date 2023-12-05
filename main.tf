terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.83.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.46.0"
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

module "entraid" {
  source                = "./modules/entraid"
  resource_group_id     = azurerm_resource_group.main.id
  entraid_tenant_domain = var.entraid_tenant_domain
  vmadmin_user_name     = var.vmadmin_user_name
  vmadmin_user_password = var.vmadmin_user_password
}

module "keyvault" {
  source                 = "./modules/keyvault"
  sys                    = var.sys
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  vmadmin_user_object_id = module.entraid.vmadmin_user_object_id
  vmadmin_user_password  = var.vmadmin_user_password
}
