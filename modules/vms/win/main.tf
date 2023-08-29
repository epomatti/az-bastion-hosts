resource "azurerm_network_interface" "windows" {
  name                = "nic-windows"
  resource_group_name = var.group
  location            = var.location

  ip_configuration {
    name                          = "windows"
    subnet_id                     = var.subnet
    private_ip_address_allocation = "Dynamic"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_windows_virtual_machine" "windows" {
  name                  = "vm-windows"
  resource_group_name   = var.group
  location              = var.location
  size                  = var.size
  admin_username        = "bastionadmin"
  admin_password        = "P@ssw0rd.123"
  network_interface_ids = [azurerm_network_interface.windows.id]

  os_disk {
    name                 = "osdisk-windows"
    caching              = "ReadOnly"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}
