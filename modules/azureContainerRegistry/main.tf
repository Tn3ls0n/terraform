resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "basic"
  admin_enabled       = true
}

resource "azurerm_role_assignment" "acr_pull" {
  scope              = azurerm_container_registry.acr.id
  role_definition_id = "AcrPull"
  principal_id       = var.spn_client_id
}
