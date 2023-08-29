resource "azurerm_public_ip" "main" {
  name                = "pip-bastion"
  location            = var.location
  resource_group_name = var.group
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.sys}"
  location            = var.location
  resource_group_name = var.group

  sku = var.sku

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
