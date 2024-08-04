# terraform user
data "azurerm_client_config" "current" {}

# key vault
resource "azurerm_key_vault" "app_vault" {
  name                       = var.key_vault_name
  location                   = var.key_vault_location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  # assign terraform user access to vault
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }

  # assign service prinicipal access to vault
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = var.spn_obj_id

    secret_permissions = [
      "Set",
      "Get",
    ]
  }
}

# add service princiapl client to vault
resource "azurerm_key_vault_secret" "client" {
  name         = "servicePrincipalClientId"
  value        = var.spn_client_id
  key_vault_id = azurerm_key_vault.app_vault.id
}

# add service secret to vault
resource "azurerm_key_vault_secret" "secret" {
  name         = "servicePrincipalSecret"
  value        = var.spn_secret
  key_vault_id = azurerm_key_vault.app_vault.id

}
