data "azuread_client_config" "current" {}

resource "azuread_application" "web_api" {
  display_name = var.api_application
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "web_api_sp" {
  client_id = azuread_application.web_api.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "web_api_sp_pw" {
  display_name         = "${azuread_application.web_api.display_name}Secret"
  service_principal_id = azuread_service_principal.web_api_sp.object_id
}
