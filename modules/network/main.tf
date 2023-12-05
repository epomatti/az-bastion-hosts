### Network ###
resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.sys}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.group
}

### Bastion Subnet ###
resource "azurerm_network_security_group" "bastion" {
  name                = "nsg-bastion"
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_network_security_rule" "bastion_inbound" {
  name                        = "BastionInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_network_security_rule" "bastion_outbound" {
  name                        = "BastionOutbound"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_subnet" "bastion" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.10.0/26"]
}


resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
}

### Linux Subnet ###
resource "azurerm_network_security_group" "linux" {
  name                = "nsg-linux"
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_network_security_rule" "linux_inbound" {
  name                        = "LinuxInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.linux.name
}

resource "azurerm_subnet" "linux" {
  name                 = "linux-subnet"
  resource_group_name  = var.group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.50.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "linux" {
  subnet_id                 = azurerm_subnet.linux.id
  network_security_group_id = azurerm_network_security_group.linux.id
}

### Windows Subnet ###
resource "azurerm_network_security_group" "windows" {
  name                = "nsg-windows"
  location            = var.location
  resource_group_name = var.group
}

resource "azurerm_network_security_rule" "windows_inbound" {
  name                        = "WindowsInbound"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.group
  network_security_group_name = azurerm_network_security_group.windows.name
}

resource "azurerm_subnet" "windows" {
  name                 = "windows-subnet"
  resource_group_name  = var.group
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.90.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "windows" {
  subnet_id                 = azurerm_subnet.windows.id
  network_security_group_id = azurerm_network_security_group.windows.id
}
