data "azurerm_client_config" "current" {}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_key_vault" "default" {
  name                       = "kv-${var.sys}${random_string.random.result}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  enable_rbac_authorization = true
}

resource "azurerm_role_assignment" "key_vault_administrator" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "key_vault_crypto_user" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.vmadmin_user_object_id
}

resource "azurerm_role_assignment" "key_vault_reader" {
  scope                = azurerm_key_vault.default.id
  role_definition_name = "Key Vault Reader"
  principal_id         = var.vmadmin_user_object_id
}

resource "azurerm_key_vault_secret" "vmadmin_password" {
  name         = "vmadmin-password"
  value        = var.vmadmin_user_password
  key_vault_id = azurerm_key_vault.default.id

  depends_on = [azurerm_role_assignment.key_vault_administrator]
}
