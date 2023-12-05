locals {
  user = var.vmadmin_user_name
}

resource "azuread_user" "administrator" {
  account_enabled     = true
  user_principal_name = "${local.user}@${var.entraid_tenant_domain}"
  display_name        = local.user
  mail_nickname       = local.user
  password            = var.vmadmin_user_password
}

resource "azurerm_role_assignment" "vm_admin" {
  scope                = var.resource_group_id
  role_definition_name = "Virtual Machine Administrator Login"
  principal_id         = azuread_user.administrator.object_id
}

resource "azurerm_role_assignment" "subscription_reader" {
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azuread_user.administrator.object_id
}
