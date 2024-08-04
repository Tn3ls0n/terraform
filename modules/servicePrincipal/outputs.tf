output "service_principal_client_id" {
  value = azuread_application.web_api.client_id
}

output "service_principal_client_secret" {
  value     = azuread_service_principal_password.web_api.value
  sensitive = true
}

output "service_principal_object_id" {
  value = azuread_service_principal.web_api.object_id
}
