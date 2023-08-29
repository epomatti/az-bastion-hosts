output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "linux_subnet_id" {
  value = azurerm_subnet.linux.id
}

output "windows_subnet_id" {
  value = azurerm_subnet.windows.id
}
