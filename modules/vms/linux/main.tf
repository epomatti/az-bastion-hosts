resource "azurerm_network_interface" "main" {
  name                = "nic-jumpbox-${var.sys}"
  resource_group_name = var.group
  location            = var.location

  ip_configuration {
    name                          = "jumpbox"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_linux_virtual_machine" "main" {
  name                  = "vm-jumpbox-${var.sys}"
  resource_group_name   = var.group
  location              = var.location
  size                  = var.size
  admin_username        = "bastionadmin"
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.main.id]

  custom_data = filebase64("${path.module}/cloud-init.sh")

  identity {
    type = "SystemAssigned"
  }

  admin_ssh_key {
    username   = "bastionadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    name                 = "osdisk-linux-${var.sys}"
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}
