resource "azurerm_public_ip" "main" {
  name                = "pip-bastion"
  location            = var.location
  resource_group_name = var.group
  allocation_method   = "Static"
  sku                 = var.sku
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-${var.sys}"
  location            = var.location
  resource_group_name = var.group

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet
    public_ip_address_id = azurerm_public_ip.main.id
  }
}
