# terraform user
data "azuread_client_config" "current" {}

# web api
resource "azuread_application" "web_api" {
  display_name = var.api_application
  owners       = [data.azuread_client_config.current.object_id]
}

# service prinicipal api
resource "azuread_service_principal" "web_api" {
  client_id = azuread_application.web_api.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# service principal password
resource "azuread_service_principal_password" "web_api" {
  display_name         = var.web_application
  service_principal_id = azuread_service_principal.web_api.object_id
}
